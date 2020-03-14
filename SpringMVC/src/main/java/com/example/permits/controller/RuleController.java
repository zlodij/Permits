package com.example.permits.controller;

import com.example.permits.model.BaseObject;
import com.example.permits.model.Rule;
import com.example.permits.service.RuleService;
import org.apache.commons.beanutils.BeanUtils;
import org.hibernate.validator.constraints.Length;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.ModelAndView;

import javax.validation.ConstraintViolation;
import javax.validation.ConstraintViolationException;
import javax.validation.Valid;
import javax.validation.constraints.NotBlank;
import java.lang.reflect.InvocationTargetException;
import java.util.*;
import java.util.stream.Collectors;

@Validated
@Controller
public class RuleController {
    @Autowired
    private RuleService service;

    private Map<String, BaseObject> cache = new HashMap<>();

    private Rule getRule(String id) {
        Rule rule = service.getRuleById(id);
        if (rule == null && cache.containsKey(id)) {
            BaseObject object = cache.get(id);
            if (object instanceof Rule) {
                rule = (Rule) object;
            }
        }
        return rule;
    } // end getRule

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
        model.addAttribute("rule", getRule(id));
        return "editRule";
    } // end getEditRuleView

    @PostMapping("/rules/{id}/rule")
    public String sendEditRuleForm(@PathVariable("id") String id,
                                   @RequestParam @Valid @NotBlank String name,
                                   @RequestParam @Valid @Length(max = 32) String description,
                                   @RequestParam String objTypes,
                                   @RequestParam String statuses) {
        Rule rule = getRule(id);

        rule.setName(name);
        rule.setDescription(description);
        rule.setObjTypes(objTypes);
        rule.setStatuses(statuses);

        service.addRule(rule);
        return "redirect:/rules";
    } // end sendEditRuleForm

    @ExceptionHandler(ConstraintViolationException.class)
    public ModelAndView errorHandler(ConstraintViolationException exception, WebRequest request) {
        String id = request.getParameter("rule_id");

        Rule rule = getRule(id);

        ModelAndView modelAndView = new ModelAndView();

        Rule finalRule = rule;
        request.getParameterNames().forEachRemaining(name -> {
            try {
                BeanUtils.setProperty(finalRule, name, request.getParameter(name));
            } catch (IllegalAccessException | InvocationTargetException e) {
                throw new RuntimeException(e);
            }
        });

        Set<ConstraintViolation<?>> violations = exception.getConstraintViolations();
        violations.forEach(violation -> {
                    if ("sendEditRuleForm.arg1".equals(violation.getPropertyPath().toString())) {
                        modelAndView.addObject("nameValidationMessage", violation.getMessage());
                    } else if ("sendEditRuleForm.arg2".equals(violation.getPropertyPath().toString())) {
                        modelAndView.addObject("descriptionValidationMessage", violation.getMessage());
                    }
                }
        );

        modelAndView.addObject("rule", rule);
        modelAndView.setViewName("editRule");
        return modelAndView;
    } // end errorHandler
} // end RuleController
