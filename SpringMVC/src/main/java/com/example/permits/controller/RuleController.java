package com.example.permits.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class RuleController {
    @GetMapping("/hello")
    public String sayHello() {
        return "index";
    } // end sayHello
} // end RuleController
