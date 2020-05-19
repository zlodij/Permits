package com.example.permits.converter;

import com.example.permits.enums.Permit;
import org.springframework.core.convert.converter.Converter;

public class StringToPermitConverter implements Converter<String, Permit> {
    public Permit convert(String source) {
        return Permit.getPermit(Integer.parseInt(source)).orElse(Permit.NONE);
    } // end convert
} // end StringToPermitConverter