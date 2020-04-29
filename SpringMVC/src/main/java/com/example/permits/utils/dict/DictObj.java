package com.example.permits.utils.dict;

/**
 * Provides simple realization of root Properties Bag to deserialize dictionaries data from JSON config with Gson.
 */
class DictObj {
    /**
     * Refers on "types-all" array of strings
     */
    String[] typesAll;
    /**
     * Refers on "statuses-all" array of inner object
     */
    StatusObj[] statusesAll;
    /**
     * Refers on "roles-all" array of strings
     */
    String[] rolesAll;
    /**
     * Refers on "aliases-all" array of strings
     */
    AliasObj[] aliasesAll;
} // end DictObj