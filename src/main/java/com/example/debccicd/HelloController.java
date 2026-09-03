package com.example.debccicd;


import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api")
public class HelloController {

    @GetMapping("/hello")
    public Map<String,String> getHello(){
        return Map.of("message","Hello from DEBC CICD demo");
    }

    @GetMapping("/health")
    public Map<String,String> getHealth(){
        return Map.of("status","UP 200 ok");
    }
}
