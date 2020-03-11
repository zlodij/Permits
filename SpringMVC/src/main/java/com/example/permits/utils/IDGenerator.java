package com.example.permits.utils;

public final class IDGenerator {
    private static int lastId = 0;

    public synchronized static String generateID(String pattern) {
        return String.format(pattern, ++lastId);
    } // end generateID
} // end IDGenerator