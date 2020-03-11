package com.example.permits.service;

import com.example.permits.model.Rule;
import org.springframework.stereotype.Service;
import org.springframework.util.ResourceUtils;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.*;

@Service
public class RuleService {
    private Map<String, Rule> rules = new HashMap<>();

    public RuleService() throws FileNotFoundException {
        File file = ResourceUtils.getFile("classpath:security-config-simple.xml");
        (new XmlDataProvider(file).getRules()).forEach(this::addRule);
    } // end default constructor

    public Rule getRuleByName(String name) {
        Rule result = null;

        Collection<Rule> rules = this.rules.values();
        for (Rule rule : rules) {
            if(rule.getName().equals(name)) {
                result = rule;
                break;
            }
        }

        return result;
    } // end getRuleByName

    public Rule getRuleById(String id) {
        return rules.get(id);
    } // end getRuleById

    public void addRule(Rule rule) {
        rules.put(rule.getId(), rule);
    } // end addRule

    public Collection<String> getNames() {
        return rules.keySet();
    } // end getNames

    public Collection<Rule> getAll() {
        return rules.values();
    } // end getAll
} // end RuleService
