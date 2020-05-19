package com.example.permits.enums;

import java.util.Arrays;
import java.util.Optional;

public enum XPermit {
    EXECUTE_PROC("EXECUTE_PROC", "Execute Procedure (EP)", "EP"),
    CHANGE_LOCATION("CHANGE_LOCATION", "Change Location (CL)", "CL"),
    CHANGE_STATE("CHANGE_STATE", "Change State (CS)", "CS"),
    CHANGE_PERMIT("CHANGE_PERMIT", "Change Permission (CP)", "CP"),
    CHANGE_OWNER("CHANGE_OWNER", "Change Ownership (CO)", "CO"),
    DELETE_OBJECT("DELETE_OBJECT", "Extended Delete (DO)", "DO"),
    CHANGE_FOLDER_LINKS("CHANGE_FOLDER_LINKS", "Change Folder Links (CFL)", "CFL");

    private final String value;
    private final String display;
    private final String acronym;

    XPermit(String value, String display, String acronym) {
        this.value = value;
        this.display = display;
        this.acronym = acronym;
    } // end constructor

    public String getValue() {
        return value;
    } // end getValue

    public String getDisplay() {
        return display;
    } // end getDisplay

    public String getAcronym() {
        return acronym;
    } // end getAcronym

    public static Optional<XPermit> getXPermit(String value) {
        return Arrays.stream(XPermit.values()).filter(xPermit -> xPermit.getValue().equalsIgnoreCase(value)).findFirst();
    } // end getPermit
} // end XPermit
