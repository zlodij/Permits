package com.example.permits.controller;

import com.example.permits.model.Accessor;
import com.example.permits.model.BaseObject;
import com.example.permits.model.Rule;
import com.example.permits.service.RuleService;
import com.example.permits.utils.dict.DictDataProvider;
import com.google.common.base.Joiner;
import com.google.common.base.Splitter;
import org.apache.commons.beanutils.BeanUtils;
import org.hibernate.validator.constraints.Length;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BeanPropertyBindingResult;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.validation.beanvalidation.SpringValidatorAdapter;
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

    @Autowired
    @Qualifier("jsr303Validator")
    private javax.validation.Validator validator;

    private final static String ATTR_STATUSES = "statuses";
    private final static String ATTR_OBJ_TYPES = "objTypes";

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

    private Accessor getAccessor(String id) {
        Accessor accessor = null;
        if (cache.containsKey(id)) {
            BaseObject object = cache.get(id);
            if (object instanceof Accessor) {
                accessor = (Accessor) object;
            }
        }
        return accessor;
    } // end getAccessor

    @GetMapping("/hello")
    public String sayHello() {
        return "index";
    } // end sayHello

    @GetMapping("/error")
    public String showError(@RequestParam String errorMessage, Model model) {
        model.addAttribute("errorMessage", errorMessage);
        return "error";
    } // end showError

    @GetMapping("/rules")
    public String getRulesView(Model model) {
        model.addAttribute("rules", service.getAll().stream()
                .sorted(Comparator.comparing(Rule::getName))
                .collect(Collectors.toCollection(ArrayList::new)));
        return "/rules";
    } // end getRulesView

    @PostMapping("/rules/delete")
    public String deleteRule(@RequestParam("rule_id") String id) {
        service.deleteRule(id);
        cache.remove(id);

        return "redirect:/rules";
    } // end deleteRule

    @GetMapping("/rules/new")
    public String getNewRuleForm(Model model) {
        Rule rule = new Rule();
        cache.put(rule.getId(), rule);

        model.addAttribute("rule", rule);
        return "redirect:/rules/" + rule.getId() + "/rule";
    } // end getNewRuleForm

    @GetMapping("/rules/{id}/rule")
    public String getRuleForm(@PathVariable("id") String id, Model model) {
        model.addAttribute("rule", getRule(id));
        model.addAttribute("dictObjTypes", DictDataProvider.getInstance().getSupportedTypes());
        return "editRule";
    } // end getRuleForm

    @GetMapping("/rules/{id}/rule/statuses")
    public String getStatusesForm(@PathVariable("id") String id, Model model) {
        Rule rule = getRule(id);

        model.addAttribute("title", "Status");
        model.addAttribute("attribute", ATTR_STATUSES);

        model.addAttribute("listSelected", Splitter.on(",").trimResults().splitToList(rule.getStatuses()));
        model.addAttribute("listAvailable", DictDataProvider.getInstance().getAvailableStatuses(rule.getObjTypes(), this.getClass().getCanonicalName()));
        return "selector";
    } // end getStatusesForm

    @GetMapping("/rules/{id}/rule/objTypes")
    public String getObjTypesForm(@PathVariable("id") String id, Model model) {
        Rule rule = getRule(id);

        model.addAttribute("title", "Object Type");
        model.addAttribute("attribute", ATTR_OBJ_TYPES);

        model.addAttribute("listSelected", Splitter.on(",").trimResults().splitToList(rule.getObjTypes()));
        model.addAttribute("listAvailable", DictDataProvider.getInstance().getSupportedTypes());
        return "selector";
    } // end getStatusesForm

    @GetMapping("/rules/{id}/accessor")
    public String getAccessorForm(@PathVariable("id") String id,
                                  @RequestParam(required = false) String parentId,
                                  Model model) {
        Accessor accessor = getAccessor(id);
        if (accessor == null) {
            if (parentId != null && parentId.length() > 0) {
                Rule rule = getRule(parentId);
                Optional<Accessor> result = rule.getAccessors().stream()
                        .filter(element -> element.getId().equals(id))
                        .findFirst();
                if (result.isPresent()) {
                    accessor = result.get();
                    cache.put(id, accessor);
                } else {
                    model.addAttribute("errorMessage", "Failed to find Rule with ID '" + parentId + "'!");
                    return "redirect:/error";
                }
            } else {
                model.addAttribute("errorMessage", "Invalid parent Rule ID '" + parentId + "' specified!");
                return "redirect:/error";
            }
        }
        model.addAttribute("listRoles", DictDataProvider.getInstance().getSupportedRoles());
        model.addAttribute("listSvcAliases", DictDataProvider.getInstance().getSupportedAliases(true));
        model.addAttribute("listNotSvcAliases", DictDataProvider.getInstance().getSupportedAliases(false));
        model.addAttribute("accessor", accessor);
        return "editAccessor";
    } // end getAccessorForm

    @PostMapping("/rules/{id}/rule")
    public String submitRuleForm(@PathVariable("id") String id,
                                 @RequestParam @Valid @NotBlank String name,
                                 @RequestParam @Valid @Length(max = 32) String description,
                                 @RequestParam(required = false) boolean addAccessor,
                                 @RequestParam(required = false) String deleteAccessor,
                                 Model model) {
        String result;

        Rule rule = getRule(id);
        rule.setName(name);
        rule.setDescription(description);

        if (addAccessor) {
            Accessor accessor = new Accessor();
            accessor.setParentId(rule.getId());
            cache.put(accessor.getId(), accessor);
            model.addAttribute("accessor", accessor);

            result = "redirect:/rules/" + accessor.getId() + "/accessor";
        } else if (deleteAccessor != null && deleteAccessor.length() > 0) {
            List<Accessor> accessors = rule.getAccessors().stream().filter(item -> !item.getId().equals(deleteAccessor)).collect(Collectors.toList());
            rule.setAccessors(accessors);
            model.addAttribute("rule", rule);
            result = "editRule";
        } else {
            service.addRule(rule);
            result = "redirect:/rules";
        }

        return result;
    } // end sendEditRuleForm

    @PostMapping("/rules/{id}/accessor")
    public String submitAccessorForm(@PathVariable("id") String id,
                                     @ModelAttribute Accessor accessor,
                                     Model model) {
        String result;

        SpringValidatorAdapter springValidator = new SpringValidatorAdapter(validator);
        BindingResult bindingResult = new BeanPropertyBindingResult(accessor, "accessor");
        springValidator.validate(accessor, bindingResult);

        if (bindingResult.hasErrors()) {
            String key = BindingResult.class.getCanonicalName() + ".accessor";
            model.addAttribute(key, bindingResult);
            model.addAttribute("listRoles", DictDataProvider.getInstance().getSupportedRoles());
            model.addAttribute("listSvcAliases", DictDataProvider.getInstance().getSupportedAliases(true));
            model.addAttribute("listNotSvcAliases", DictDataProvider.getInstance().getSupportedAliases(false));
            result = "editAccessor";
        } else {
            Rule rule = getRule(accessor.getParentId());
            if (rule != null) {
                List<Accessor> accessors = rule.getAccessors().stream().filter(item -> !item.getId().equals(accessor.getId())).collect(Collectors.toList());
                accessors.add(accessor);
                rule.setAccessors(accessors);
                result = "redirect:/rules/" + rule.getId() + "/rule";
                model.addAttribute("rule", rule);
                cache.put(id, accessor);
            } else {
                model.addAttribute("errorMessage", "Failed to find Rule with ID '" + accessor.getParentId() + "'!");
                result = "redirect:/error";
            }
        }

        return result;
    } // end submitAccessorForm

    @PostMapping("/rules/{id}/rule/selector")
    public String submitSelectorForm(@PathVariable("id") String id,
                                     @RequestParam ArrayList<String> selected,
                                     @RequestParam String attribute,
                                     Model model) {
        String result;

        Rule rule = getRule(id);
        if (rule != null) {
            //TODO collect values
            if (ATTR_STATUSES.equals(attribute)) {
                rule.setStatuses(Joiner.on(", ").skipNulls().join(selected));
            } else if (ATTR_OBJ_TYPES.equals(attribute)) {
                rule.setObjTypes(Joiner.on(", ").skipNulls().join(selected));
            }

            result = "redirect:/rules/" + rule.getId() + "/rule";
            model.addAttribute("rule", rule);
        } else {
            model.addAttribute("errorMessage", "Failed to find Rule with ID '" + id + "'!");
            result = "redirect:/error";
        }

        return result;
    } // end submitSelectorForm

    @ExceptionHandler(ConstraintViolationException.class)
    public ModelAndView errorHandler(ConstraintViolationException exception, WebRequest request) {
        ModelAndView modelAndView = new ModelAndView();

        String id = request.getParameter("rule_id");
        if (id != null) {
            Rule rule = getRule(id);
            request.getParameterNames().forEachRemaining(name -> {
                try {
                    BeanUtils.setProperty(rule, name, request.getParameter(name));
                } catch (IllegalAccessException | InvocationTargetException e) {
                    throw new RuntimeException(e);
                }
            });

            Set<ConstraintViolation<?>> violations = exception.getConstraintViolations();
            violations.forEach(violation -> {
                        if ("submitRuleForm.arg1".equals(violation.getPropertyPath().toString())) {
                            modelAndView.addObject("nameValidationMessage", violation.getMessage());
                        } else if ("submitRuleForm.arg2".equals(violation.getPropertyPath().toString())) {
                            modelAndView.addObject("descriptionValidationMessage", violation.getMessage());
                        }
                    }
            );

            modelAndView.addObject("rule", rule);
            modelAndView.setViewName("editRule");
        } else {
            // TODO Redirect to error page!
            modelAndView.addObject("errorMessage", exception);
            modelAndView.setViewName("error");
        }

        return modelAndView;
    } // end errorHandler
} // end RuleController
