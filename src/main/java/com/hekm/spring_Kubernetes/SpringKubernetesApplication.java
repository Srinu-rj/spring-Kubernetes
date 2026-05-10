package com.hekm.spring_Kubernetes;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@Controller
@RestController
public class SpringKubernetesApplication {

    public static void main(String[] args) {
        SpringApplication.run(SpringKubernetesApplication.class, args);
    }

    @GetMapping("/kubernetes")
    public String index() {
        return "Successfully Deployed a Springboard application In Kubernetes 😇🤩🤩😎✌️🙌";
    }

    @GetMapping("/home")
    public String home() {
        return "HomePage";
    }

    @GetMapping("/wellcome")
    public String wellCome() {
        return "WellComePage";
    }

}
