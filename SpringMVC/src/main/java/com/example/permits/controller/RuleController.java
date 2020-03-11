package com.example.permits.controller;

import com.example.permits.model.Rule;
import com.example.permits.service.RuleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.stream.Collectors;

@Controller
public class RuleController {
    @Autowired
    private RuleService service;

    @GetMapping("/hello")
    public String sayHello() {
        return "index";
    } // end sayHello

    @GetMapping("/rules")
    public String getRulesView(Model model) {
        model.addAttribute("rules", service.getAll().stream().sorted(Comparator.comparing(Rule::getName)).collect(Collectors.toCollection(ArrayList::new)));
        return "/rules";
    } // end getRulesView
} // end RuleController
