#!/usr/bin/env groovy

final String AWS_REGION      = env.AWS_REGION      ?: 'us-east-1'
final String AWS_ACCOUNT_ID  = env.AWS_ACCOUNT_ID  ?: error('AWS_ACCOUNT_ID is not set as a Jenkins global variable')
final String ECR_REGISTRY    = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
final String ECR_REPOSITORY  = 'spring-application-k8s'
final String EKS_CLUSTER     = 'my-eks-cluster' // change your cluster
final String HELM_RELEASE    = 'backend'
final String HELM_CHART_PATH = './helm-charts/backend'


podTemplate(
    serviceAccount: 'jenkins-deployer',
    containers: [
        containerTemplate(
            name:    'dind',
            image:   'srinu641/spring-application-k8s:V2.0',
            privileged: true,
            ttyEnabled: false,
            envVars: [
                envVar(key: 'DOCKER_TLS_CERTDIR', value: '')   // disable TLS for simplicity inside the pod
            ]
        ),
        containerTemplate(
            name:      'maven',
            image:     'maven:3.9.6-eclipse-temurin-21',
            ttyEnabled: true,
            command:   'cat',
            envVars: [
                // Cache the local Maven repo on the pod to speed up dependency resolution
                envVar(key: 'MAVEN_OPTS', value: '-Dmaven.repo.local=/root/.m2/repository')
            ]
        ),
        containerTemplate(
            name:      'tools',
            image:     'srinu641/spring-application-k8s:V2.0',      // Requires: awscli, helm, kubectl, docker-cli
            ttyEnabled: true,
            command:   'cat',
            envVars: [
                envVar(key: 'DOCKER_HOST',    value: 'tcp://localhost:2375'),
                envVar(key: 'AWS_REGION',     value: AWS_REGION),
                envVar(key: 'ECR_REGISTRY',   value: ECR_REGISTRY),
                envVar(key: 'ECR_REPOSITORY', value: ECR_REPOSITORY),
                envVar(key: 'EKS_CLUSTER',    value: EKS_CLUSTER),
            ]
        )
    ]
) {
    node(POD_LABEL) {
        def server = Artifactory.server('jfrog-instance')

        stage('Checkout') {
            checkout scm
            // Use the full SHA for image tagging (immutable + traceable)
            env.GIT_SHORT_SHA = sh(
                script: 'git rev-parse --short=12 HEAD',
                returnStdout: true
            ).trim()
            env.IMAGE_TAG = env.GIT_SHORT_SHA
            echo "Image tag: ${env.IMAGE_TAG}"
        }

        stage('Upload to Artifactory') {
                    // This uses the Jenkins plugin DSL for simplicity
                    def uploadSpec = """{
                        "files": [
                            {
                                "pattern": "target/*.jar",
                                "target": "libs-${env.DEPLOY_ENV}-local/${env.ECR_REPOSITORY}/${env.IMAGE_TAG}/"
                            }
                        ]
                    }"""

                    // Upload the artifact and record build info for traceability
                    def buildInfo = server.upload spec: uploadSpec
                    buildInfo.retention maxBuilds: 10, deleteBuildArtifacts: true
                    server.publishBuildInfo buildInfo
        }

        stage('Resolve Environment') {
            if (env.TAG_NAME ==~ /^v\d+\.\d+\.\d+$/) {
                env.DEPLOY_ENV  = 'qa-release'
                env.NAMESPACE   = 'back-end-qa-namespace'
                env.HELM_VALUES = 'values-qa.yaml'
            } else if (env.BRANCH_NAME == 'master') {
                env.DEPLOY_ENV  = 'dev-release'
                env.NAMESPACE   = 'back-end-dev-namespace'
                env.HELM_VALUES = 'values-dev.yaml'
            } else if(env.BRANCH_NAME == 'release'){
                env.DEPLOY_ENV  = 'prod-release'
                env.NAMESPACE   = 'back-end-prod-namespace'
                env.HELM_VALUES = 'values-prod.yaml'
            } error("Pipeline only runs on 'main' or semantic version tags. Ref: ${env.BRANCH_NAME ?: env.TAG_NAME}")
            }
            echo "Deploying to: ${env.DEPLOY_ENV} | namespace: ${env.NAMESPACE} | tag: ${env.IMAGE_TAG}"
        }

        stage('Lint & Unit Tests') {
            container('maven') {
                sh 'mvn checkstyle:check --batch-mode'
                sh 'mvn test --batch-mode'

                sh """
                    helm lint ${HELM_CHART_PATH} \
                      --values ${HELM_CHART_PATH}/${env.HELM_VALUES} \
                      --strict
                """
            }
        }

        stage('Build JAR') {
            container('maven') {
                sh 'mvn package -DskipTests --batch-mode'
            }
        }

        stage('Build & Push Image') {
            container('tools') {
                sh """
                    # Authenticate Docker to ECR — IRSA supplies the credentials
                    aws ecr get-login-password --region ${AWS_REGION} \
                      | docker login --username AWS --password-stdin ${ECR_REGISTRY}

                    # Build with two tags:
                    #   :<git-sha>    — immutable, used for K8s deployment
                    #   :<env>-latest — mutable, for human reference only
                    docker build \\
                      --tag  ${ECR_REGISTRY}/${ECR_REPOSITORY}:${env.IMAGE_TAG} \\
                      --tag  ${ECR_REGISTRY}/${ECR_REPOSITORY}:${env.DEPLOY_ENV}-latest \\
                      --label org.opencontainers.image.revision=${env.IMAGE_TAG} \\
                      --label org.opencontainers.image.environment=${env.DEPLOY_ENV} \\
                      .

                    docker push ${ECR_REGISTRY}/${ECR_REPOSITORY}:${env.IMAGE_TAG}
                    docker push ${ECR_REGISTRY}/${ECR_REPOSITORY}:${env.DEPLOY_ENV}-latest
                """
            }
        }

//         if (env.DEPLOY_ENV == 'production') {
//             stage('Approval Gate — Production') {
//                 timeout(time: 30, unit: 'MINUTES') {
//                     input(
//                         message:   "Deploy image ${env.IMAGE_TAG} to PRODUCTION?",
//                         ok:        'Deploy Now',
//                         submitter: 'release-engineers'   // Jenkins user/group with approval rights
//                     )
//                 }
//             }
//         }

//         stage("Deploy to ${env.DEPLOY_ENV}") {
//             container('tools') {
//                 sh """
//                     # Pull kubeconfig — IRSA provides the credentials for eks:DescribeCluster
//                     aws eks update-kubeconfig \
//                       --name   ${EKS_CLUSTER} \
//                       --region ${AWS_REGION}
//
//                     # Actual K8s API access is controlled by RBAC (see k8s-rbac.yaml),
//                     # not by IAM. The IAM role only gets past the EKS auth layer.
//                     helm upgrade --install ${HELM_RELEASE} ${HELM_CHART_PATH} \\
//                       --namespace        ${env.NAMESPACE} \\
//                       --create-namespace \\
//                       --values           ${HELM_CHART_PATH}/${env.HELM_VALUES} \\
//                       --set              image.repository=${ECR_REGISTRY}/${ECR_REPOSITORY} \\
//                       --set              image.tag=${env.IMAGE_TAG} \\
//                       --set              environment=${env.DEPLOY_ENV} \\
//                       --atomic \\
//                       --cleanup-on-fail \\
//                       --timeout          5m \\
//                       --wait
//                 """
//             }
//         }

//         stage('Verify Rollout') {
//             container('tools') {
//                 sh """
//                     kubectl rollout status deployment/${HELM_RELEASE} \
//                       --namespace ${env.NAMESPACE} \
//                       --timeout   300s
//                 """
//             }
//         }

    }
}