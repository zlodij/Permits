package com.example.permits.controller;

import com.example.permits.model.BaseObject;
import com.example.permits.model.Rule;
import com.example.permits.service.RuleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.*;
import java.util.stream.Collectors;

@Controller
public class RuleController {
    @Autowired
    private RuleService service;

    private Map<String, BaseObject> cache = new HashMap<>();

    @GetMapping("/hello")
    public String sayHello() {
        return "index";
    } // end sayHello

    @GetMapping("/rules")
    public String getRulesView(Model model) {
        model.addAttribute("rules", service.getAll().stream().sorted(Comparator.comparing(Rule::getName)).collect(Collectors.toCollection(ArrayList::new)));
        return "/rules";
    } // end getRulesView

    @GetMapping("/rules/new")
    public String getNewRuleView(Model model) {
        Rule rule = new Rule();
        cache.put(rule.getId(), rule);

        model.addAttribute("rule", rule);
        return "redirect:/rules/" + rule.getId() + "/rule";
    } // end getNewRuleView

    @GetMapping("/rules/{id}/rule")
    public String getEditRuleView(@PathVariable("id") String id, Model model) {
        Rule rule = service.getRuleById(id);
        if (rule == null && cache.containsKey(id)) {
            BaseObject object = cache.get(id);
            if (object instanceof Rule) {
                rule = (Rule) object;
            }
        }
        model.addAttribute("rule", rule);
        return "editRule";
    } // end getEditRuleView

    @PostMapping("/rules/{id}/rule")
    public String sendEditRuleForm(@PathVariable("id") String id,
                                   @ModelAttribute @Valid Rule rule,
                                   BindingResult bindingResult,
                                   Model model) {
        String result;

        if (bindingResult.hasErrors()) {
            result = "editRule";
        } else {
            service.addRule(rule);
            result = "redirect:/rules";
        }

        return result;
    } // end sendEditRuleForm
} // end RuleController
