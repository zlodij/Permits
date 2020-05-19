package com.example.permits.converter;

import com.example.permits.enums.OrgLevel;
import org.springframework.core.convert.converter.Converter;

public class StringToOrgLevelsConverter implements Converter<String, OrgLevel> {
    public OrgLevel convert(String source) {
        return OrgLevel.getOrgLevel(source).orElseThrow(RuntimeException::new);
    } // end convert
} // end StringToOrgLevelsConverter

