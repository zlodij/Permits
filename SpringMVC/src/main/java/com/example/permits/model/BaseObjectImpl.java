package com.example.permits.model;

import com.example.permits.utils.IDGenerator;

abstract class BaseObjectImpl implements BaseObject {
    private String id;
    private String parentId;

    public BaseObjectImpl() {
        this.id = IDGenerator.generateID(getIdPattern());
        this.parentId = IDGenerator.NULL_ID;
    } // end default constructor

    public String getId() {
        return id;
    } // end getId

    public void setId(String id) {
        this.id = id;
    } // end setId

    @Override
    public String getParentId() {
        return parentId;
    } // end getParentId

    @Override
    public void setParentId(String id) {
        parentId = id;
    } // end setParentId

    protected abstract String getIdPattern(); // end getIdPattern
} // end BaseObject