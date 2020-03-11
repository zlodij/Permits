package com.example.permits.model;

import com.example.permits.utils.IDGenerator;

abstract class BaseObject {
    private String id;

    public BaseObject() {
        this.id = IDGenerator.generateID(getIdPattern());
    } // end default constructor

    public String getId() {
        return id;
    } // end getId

    public void setId(String id) {
        this.id = id;
    } // end setId

    protected abstract String getIdPattern(); // end getIdPattern
} // end BaseObject