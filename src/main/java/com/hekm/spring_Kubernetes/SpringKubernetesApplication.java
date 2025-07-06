package com.hekm.spring_Kubernetes;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@SpringBootApplication
@Controller
@RequestMapping("/api")
public class SpringKubernetesApplication {
//	dckr_pat_wcA-E0phfP25ve7s6cf4LQ8yF7A
//	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
	public static void main(String[] args) {
		SpringApplication.run(SpringKubernetesApplication.class, args);
	}
	@GetMapping("/")
	public String home(){
		return "HomePage";
	}

	@GetMapping("/home")
	public String homeDemo(){
		return "sjdgfudskgfdshvhbdshfbdsufbdshdsbvjdsbvjsdbcjd";
	}


}
