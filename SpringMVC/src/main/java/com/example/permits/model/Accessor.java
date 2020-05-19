package com.example.permits.model;

import com.example.permits.enums.*;

import javax.validation.constraints.NotBlank;
import java.util.Collection;
import java.util.HashSet;
import java.util.Set;

public class Accessor extends BaseObjectImpl {
    private final static String ID_PATTERN = "A%07d";

    @NotBlank()
    private String name;
    private Boolean alias;
    private Boolean svc;
    private Permit permit;
    private final Set<XPermit> xPermits = new HashSet<>();
    private final Set<OrgLevel> orgLevels = new HashSet<>();

    public Accessor() {
        this("", false, false, Permit.NONE, null, null);
    } // end default constructor

    public Accessor(String name, boolean isAlias, boolean isSvc, Permit permit, Collection<XPermit> xPermits, Collection<OrgLevel> orgLevels) {
        super();
        setName(name);
        setAlias(isAlias);
        setSvc(isSvc);
        setPermit(permit);
        setXPermits(xPermits);
        setOrgLevels(orgLevels);
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

    public Collection<OrgLevel> getOrgLevels() {
        return orgLevels;
    } // end getOrgLevels

    public void setOrgLevels(Collection<OrgLevel> orgLevels) {
        this.orgLevels.clear();
        if (orgLevels != null) {
            this.orgLevels.addAll(orgLevels);
        }
    } // end setOrgLevels

    public Permit getPermit() {
        return permit;
    } // end getPermit

    public void setPermit(Permit permit) {
        this.permit = permit;
    } // end setPermit

    public boolean isSvc() {
        return svc;
    } // end isSvc

    public void setSvc(boolean svc) {
        this.svc = svc;
    } // end setSvc

    public Collection<XPermit> getXPermits() {
        return xPermits;
    } // end getXPermits

    public void setXPermits(Collection<XPermit> xPermits) {
        this.xPermits.clear();
        if (xPermits != null) {
            this.xPermits.addAll(xPermits);
        }
    } // end setXPermits

    public boolean hasXPermit(XPermit xPermit) {
        return getXPermits().contains(xPermit);
    } // end hasXPermit

    public boolean hasOrgLevel(OrgLevel orgLevel) {
        return getOrgLevels().contains(orgLevel);
    } // end hasOrgLevel

    public void setName(String name) {
        this.name = name;
    } // end setName

    @Override
    public String toString() {
        return "{\"id\": \"" + getId() +
                "\", \"parentId\": \"" + getParentId() +
                "\", \"name\": \"" + getName() +
                "\", \"permit\": \"" + getPermit() +
                "\", \"alias\": \"" + isAlias() +
                "\", \"svc\": \"" + isSvc() +
                "\", \"xPermits\": \"" + getXPermits() +
                "\", \"orgLevels\": \"" + getOrgLevels() + "\"}";
    } // end toString
} // end Accessor
