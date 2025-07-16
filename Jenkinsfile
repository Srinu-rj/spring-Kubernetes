pipeline {
   agent any

   tools {
     jdk 'jdk17'
     maven 'maven3'
   }

  enviornment {
      SCANNER_HOME= tool 'sonar-scanner'
  }

stages {
 stage('Git Checkout') {
        steps {
               git branch: 'master', url:'https://github.com/Srinu-rj/spring-Kubernetes.git'

        }

        stage('Compile') {
            steps {
                sh "mvn compile"
            }
        }

        stage('Test') {
            steps {
                sh "mvn test"
            }
        }

        stage('File System Scan') {
            steps {
                sh "trivy fs --format table -o trivy-fs-report.html ."
            }
        }

        stage('SonarQube Analsyis') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner Dsonar.projectName=spring-application -Dsonar.projectKey=spring-application \
                            -Dsonar.java.binaries=. '''
                }
            }
        }

        stage('Quality Gate') {
            steps {
                script {
                  waitForQualityGate abortPipeline: false, credentialsId: 'sonar-token'
                }
            }
        }

        stage('Build') {
            steps {
               sh "mvn package"
            }
        }


        stage('Build & Tag Docker Image') {
            steps {
               script {
                   withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                            sh "docker build -t spring-application-k8s ."
                    }
               }
            }
        }

        // Install Trivy in your VM
        stage('Docker Image Scan') {
            steps {
                sh "trivy image --format table -o trivy-image-report.html adijaiswal/boardshack:latest "
            }
        }

        stage('Tag & Push Docker Image') {
            steps {
               script {
                   withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                            sh "docker tag spring-application-k8s srinu641/spring-application-k8s:v4.0"
                            sh "docker push srinu641/spring-application-k8s:v4.0"

                    }
               }
            }
        }

        stage('Deploy To Kubernetes') {
            steps {
               withKubeConfig(caCertificate: '',
                              clusterName: 'kubernetes',
                              contextName: '',
                              credentialsId: 'k8-cred',
                              namespace: 'webapps',
                              restrictKubeConfigAccess: false,
                              serverUrl: 'https://172.31.8.146:6443') {

                        sh "kubectl apply -f deployment-service.yaml"
                }
            }
        }

        stage('Verify the Deployment') {
            steps {
               withKubeConfig(caCertificate: '',
                              clusterName: 'kubernetes',
                              contextName: '',
                              credentialsId: 'k8-cred',
                              namespace: 'webapps',
                              restrictKubeConfigAccess: false,
                              serverUrl: 'https://172.31.8.146:6443')
                               {
                        sh "kubectl get pods -n webapps"
                        sh "kubectl get svc -n webapps"
                }
            }
        }


  }
 }

}
