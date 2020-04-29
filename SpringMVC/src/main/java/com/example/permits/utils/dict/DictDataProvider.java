package com.example.permits.utils.dict;

import com.google.gson.FieldNamingPolicy;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.stream.JsonReader;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Provides access to the dictionaries data associated with application.
 */
public final class DictDataProvider {
    /**
     * Available instance of provider
     */
    private static DictDataProvider provider = null;
    /**
     * List of supported object types
     */
    private List<String> listTypes = new ArrayList<>();
    /**
     * List of supported user roles
     */
    private List<String> listRoles = new ArrayList<>();
    /**
     * List of supported service aliases
     */
    private List<String> listSvcAliases = new ArrayList<>();
    /**
     * List of supported not-service aliases
     */
    private List<String> listNoSvcAliases = new ArrayList<>();
    /**
     * Contains enumeration of lists with available statuses mapped by combination of type and service attributes
     */
    private Map<String, List<String>> mapStatuses = new HashMap<>();

    /**
     * Initialises provider instance with data from configuration file
     */
    private DictDataProvider() {
        GsonBuilder gsonBuilder = new GsonBuilder();
        // Notify builder to support dashes in field names
        gsonBuilder.setFieldNamingPolicy(FieldNamingPolicy.LOWER_CASE_WITH_DASHES);
        // Create a new Gson instance with your customized configuration
        Gson gson = gsonBuilder.create();

        // Get an URL that refers on configuration file associated with current application
        URL url = this.getClass().getResource("/dict/dictionaries.json");
        // Read data from file or throw corresponding exception otherwise
        if (url != null) {
            try {
                // Create buffered read for provider file
                BufferedReader br = new BufferedReader(new FileReader(new File(url.toURI())));
                // Create new JsonReader
                JsonReader jsonReader = new JsonReader(br);
                // Read provider data from provider file
                DictObj data = gson.fromJson(jsonReader, DictObj.class);
                // Get an array of all supported object types and convert it into the list
                listTypes = Arrays.stream(data.typesAll).sorted().collect(Collectors.toList());
                // Get an array of all supported user roles and convert it into the list
                listRoles = Arrays.stream(data.rolesAll).sorted().collect(Collectors.toList());

                // Get an array of all supported aliases and convert it into two separated lists depending on service sign of every item
                List<AliasObj> listAliasesAll = Arrays.stream(data.aliasesAll).collect(Collectors.toList());
                listSvcAliases = listAliasesAll.stream()
                        .filter(aliasObj -> aliasObj.service)
                        .map(aliasObj -> aliasObj.alias)
                        .sorted().collect(Collectors.toList());
                listNoSvcAliases = listAliasesAll.stream()
                        .filter(aliasObj -> !aliasObj.service)
                        .map(aliasObj -> aliasObj.alias)
                        .sorted().collect(Collectors.toList());

                // Populate map with available statuses
                for (StatusObj statusObj : data.statusesAll) {
                    // Generate key to store list in the map
                    String key = buildKey(statusObj.type, statusObj.service);
                    // Get an array of statuses available for current combination of type and service
                    // and convert it into the list
                    List<String> statuses = Arrays.stream(statusObj.statuses).sorted().collect(Collectors.toList());
                    // Put current statuses list into the map
                    mapStatuses.put(key, statuses);
                }
            } catch (FileNotFoundException | URISyntaxException e) {
                // Drive the exception to upper application layers
                throw new RuntimeException(e);
            }
        } else {
            // TODO Throw corresponding exception
        }
    } // end constructor

    /**
     * Returns a {@code String} with a key as a result of input parameters conjunction.
     *
     * @param type    an object type name
     * @param service a service code
     * @return a {@code String} with a generated key
     */
    private static String buildKey(String type, String service) {
        // Validate input parameter
        Objects.requireNonNull(type, "Type parameter is required!");
        // Build a key
        StringBuilder result = new StringBuilder(type);
        if (service != null && service.length() > 0) {
            result.append("::").append(service);
        }

        return result.toString();
    } // end buildKey

    /**
     * Returns a {@code List} of object types supported by application.
     *
     * @return a {@code List} of object types
     */
    public List<String> getSupportedTypes() {
        return listTypes;
    } // end getSupportedTypes

    /**
     * Returns a {@code List} of user roles supported by application.
     *
     * @return a {@code List} of user roles
     */
    public List<String> getSupportedRoles() {
        return listRoles;
    } // end getSupportedRoles

    /**
     * Returns a {@code List} of aliases supported by application.
     *
     * @param service whether aliases should have service sign or not
     * @return a {@code List} of service or not-service aliases
     */
    public List<String> getSupportedAliases(boolean service) {
        return service ? listSvcAliases : listNoSvcAliases;
    } // end getSupportedAliases

    /**
     * Returns a {@code List} of statuses available for current combination of input parameters.
     *
     * @param type    an object type name
     * @param service a service code
     * @return a {@code List} of available statuses or {@code null}
     */
    public List<String> getAvailableStatuses(String type, String service) {
        return mapStatuses.get(buildKey(type, service));
    } // end getAvailableStatuses

    /**
     * Returns the dictionaries data provider object associated with the current Java application.
     *
     * @return the <code>DictDataProvider</code> object associated with the current Java application.
     */
    public static DictDataProvider getInstance() {
        if (provider == null) {
            provider = new DictDataProvider();
        }

        return provider;
    } // end getInstance
} // end DictDataProvider