package com.example.permits.model;

import javax.validation.constraints.NotBlank;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

public class Rule extends BaseObjectImpl {
    private final static String ID_PATTERN = "P%07d";

    @NotBlank(message = "Name is required!")
    private String name;
    private String description;
    private String objTypes;
    private String statuses;
    private List<Accessor> accessors = new ArrayList<>();

    public Rule() {
        this("", "", "", "", new ArrayList<>());
    } // end default constructor

    public Rule(String name, String description, String objTypes, String statuses, List<Accessor> accessors) {
        super();
        setName(name);
        setDescription(description);
        setObjTypes(objTypes);
        setStatuses(statuses);
        setAccessors(accessors);
    } // end constructor

    @Override
    protected String getIdPattern() {
        return ID_PATTERN;
    } // end getIdPattern

    public String getObjTypes() {
        return objTypes;
    } // end getTypes

    public String getStatuses() {
        return statuses;
    } // end getStatuses

    public List<Accessor> getAccessors() {
        return accessors.stream().sorted(Comparator.comparing(Accessor::getName)).collect(Collectors.toList());
    } // end getAccessors

    public String getName() {
        return name;
    } // end getName

    public String getDescription() {
        return description;
    } // end getDescription

    public void setDescription(String description) {
        this.description = description;
    } // end setDescription

    public void setName(String name) {
        this.name = name;
    } // end setName

    public void setAccessors(List<Accessor> accessors) {
        this.accessors.clear();
        this.accessors.addAll(accessors);
        getAccessors().forEach(accessor -> accessor.setParentId(getId()));
    } // end setAccessors

    public void setObjTypes(String objTypes) {
        this.objTypes = objTypes;
    } // end setObjTypes

    public void setStatuses(String statuses) {
        this.statuses = statuses;
    } // end setStatuses

    @Override
    public String toString() {
        StringBuffer buffer = new StringBuffer();
        getAccessors().forEach(accessor -> buffer.append(", ").append(accessor.toString()));

        return "{\"id\": \"" + getId() +
                "\", \"name\": \"" + getName() +
                "\", \"description\": \"" + getDescription() +
                "\", \"objTypes\": \"" + getObjTypes() +
                "\", \"statuses\": \"" + getStatuses() +
                "\", \"accessors\": [" + (buffer.length() > 0 ? buffer.substring(2) : buffer.toString()) + "]}";
    } // end toString
} // end PermitRule