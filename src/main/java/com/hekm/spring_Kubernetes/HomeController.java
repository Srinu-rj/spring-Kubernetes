package com.hekm.spring_Kubernetes;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;


@Controller
public class HomeController {

    @GetMapping("/")
    public String home(){
        return "HomePage";
    }
    @GetMapping("/HomePage")
    public String homePage(){
        return "k;sjdgkfgj:";
    }




}
