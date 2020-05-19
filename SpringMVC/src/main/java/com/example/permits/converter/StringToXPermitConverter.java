package com.example.permits.converter;

import com.example.permits.enums.XPermit;
import org.springframework.core.convert.converter.Converter;

public class StringToXPermitConverter implements Converter<String, XPermit> {
    public XPermit convert(String source) {
        return XPermit.getXPermit(source).orElseThrow(RuntimeException::new);
    } // end convert
} // end StringToXPermitConverter
