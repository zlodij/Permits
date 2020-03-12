package com.example.permits.model;

import javax.validation.constraints.*;

public class Accessor extends BaseObjectImpl {
    private final static String ID_PATTERN = "A%07d";

    @NotBlank()
    private String name;
    private Boolean alias;
    private Boolean svc;
    @DecimalMin(value = "1")
    @DecimalMax(value = "7")
    private Integer permit;
    private String xPermits;
    private String orgLevels;

    public Accessor() {
        this("", false, false, 0, "", "");
    } // end default constructor

    public Accessor(String name, boolean isAlias, boolean isSvc, int permit, String xPermits, String orgLevels) {
        super();
        this.name = name;
        this.alias = isAlias;
        this.svc = isSvc;
        this.permit = permit;
        this.xPermits = xPermits;
        this.orgLevels = orgLevels;
    } // end constructor

    @Override
    protected String getIdPattern() {
        return ID_PATTERN;
    } // end getIdPattern

    public String getName() {
        return name;
    } // end getName

    public boolean isAlias() {
        return alias;
    } // end isAlias

    public void setAlias(boolean alias) {
        this.alias = alias;
    } // end setAlias

    public String getOrgLevels() {
        return orgLevels;
    } // end getOrgLevels

    public void setOrgLevels(String orgLevels) {
        this.orgLevels = orgLevels;
    } // end setOrgLevels

    public int getPermit() {
        return permit;
    } // end getPermit

    public void setPermit(int permit) {
        this.permit = permit;
    } // end setPermit

    public boolean isSvc() {
        return svc;
    } // end isSvc

    public void setSvc(boolean svc) {
        this.svc = svc;
    } // end setSvc

    public String getXPermits() {
        return xPermits;
    } // end getXPermits

    public void setXPermits(String xPermits) {
        this.xPermits = xPermits;
    } // end setXPermits

    public void setName(String name) {
        this.name = name;
    } // end setName

    @Override
    public String toString() {
        return "{\"id\": \"" + getId() +
                "\", \"name\": \"" + getName() +
                "\", \"permit\": \"" + getPermit() +
                "\", \"alias\": \"" + isAlias() +
                "\", \"svc\": \"" + isSvc() +
                "\", \"xPermits\": \"" + getXPermits() +
                "\", \"orgLevels\": \"" + getOrgLevels() + "\"}";
    } // end toString
} // end Accessor
