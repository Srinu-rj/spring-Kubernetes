package com.hekm.spring_Kubernetes;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;


@SpringBootApplication
@Controller

public class SpringKubernetesApplication {

    public static void main(String[] args) {
        SpringApplication.run(SpringKubernetesApplication.class, args);
    }

    @GetMapping("/")
    public String home() {
        return "HomePage";
    }


}
