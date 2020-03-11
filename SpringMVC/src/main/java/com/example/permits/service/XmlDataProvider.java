package com.example.permits.service;

import com.example.permits.model.Accessor;
import com.example.permits.model.Rule;
import org.apache.commons.io.FileUtils;
import org.w3c.dom.*;
import org.xml.sax.SAXException;

import javax.xml.parsers.*;
import java.io.*;
import java.util.*;

final class XmlDataProvider {
    private static final String ACCESS_RULE = "rule";
    private static final String RULE_NAME = "name";
    private static final String RULE_DESCR = "description";
    private static final String RULE_OBJ_TYPE = "obj-types";
    private static final String RULE_STATUS = "statuses";
    private static final String ACCESSOR = "accessor";
    private static final String ACCESSOR_NAME = "name";
    private static final String ACCESSOR_PERMIT = "permit";
    private static final String ACCESSOR_XPERMITS = "xpermits";
    private static final String ACCESSOR_LEVELS = "org-levels";
    private static final String ACCESSOR_IS_ALIAS = "alias";
    private static final String ACCESSOR_IS_SVC = "svc";
    private static final String SECURITY_CONFIG = "security-config";

    private static final String REDUNDANT_XML_SYMBOLS = "[\t\n]*";

    private List<Rule> rules = new ArrayList<Rule>();

    public XmlDataProvider(File file) {
        try {
            byte[] content = FileUtils.readFileToByteArray(file);
            InputStream is = new ByteArrayInputStream(content);
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder db = dbf.newDocumentBuilder();
            Document doc = db.parse(is);

            doc.getDocumentElement().normalize();
            Element rootElement = doc.getDocumentElement();
            if (rootElement != null) {
                NodeList list = rootElement.getElementsByTagName(ACCESS_RULE);
                if (list != null && list.getLength() > 0) {
                    for (int i = 0; i < list.getLength(); i++) {
                        Element accessRule = (Element) list.item(i);
                        NodeList childList = accessRule.getChildNodes();
                        String ruleName = null;
                        String ruleDescr = "";
                        String ruleObjTypes = null;
                        String ruleStatuses = null;
                        for (int j = 0; j < childList.getLength(); j++) {
                            Node child = childList.item(j);
                            if (child.getNodeType() == Node.ELEMENT_NODE && RULE_NAME.equals(child.getNodeName())) {
                                ruleName = child.getTextContent().replaceAll(REDUNDANT_XML_SYMBOLS, "").trim();
                            }
                            if (child.getNodeType() == Node.ELEMENT_NODE && RULE_DESCR.equals(child.getNodeName())) {
                                ruleDescr = child.getTextContent().replaceAll(REDUNDANT_XML_SYMBOLS, "").trim();
                            }
                            if (child.getNodeType() == Node.ELEMENT_NODE && RULE_OBJ_TYPE.equals(child.getNodeName())) {
                                ruleObjTypes = child.getTextContent().replaceAll(REDUNDANT_XML_SYMBOLS, "").trim();
                            }
                            if (child.getNodeType() == Node.ELEMENT_NODE && RULE_STATUS.equals(child.getNodeName())) {
                                ruleStatuses = child.getTextContent().replaceAll(REDUNDANT_XML_SYMBOLS, "").trim();
                            }
                            if (ruleName != null && ruleObjTypes != null && ruleStatuses != null) {
                                break;
                            }
                        }
                        if (ruleName != null && ruleObjTypes != null && ruleStatuses != null) {
                            List<Accessor> accessors = new ArrayList<>();
                            for (int j = 0; j < childList.getLength(); j++) {
                                Node child = childList.item(j);
                                if (child.getNodeType() == Node.ELEMENT_NODE && ACCESSOR.equals(child.getNodeName())) {
                                    Accessor accessor = readAccessor(child);
                                    if (accessor != null) {
                                        accessors.add(readAccessor(child));
//                                        rule.addAccessor(readAccessor(child));
                                    }
                                }
                            }

                            Rule rule = new Rule(ruleName,
                                    ruleDescr,
//                                    Splitter.on(",").trimResults().splitToList(ruleObjTypes),
//                                    Splitter.on(",").trimResults().splitToList(ruleStatuses)
                                    ruleObjTypes,
                                    ruleStatuses,
                                    accessors);


                            rules.add(rule);
                        }
                    }
                }
            }
        } catch (IOException | ParserConfigurationException | SAXException e) {
            // TODO Decorate it!
            throw new RuntimeException(e);
        }
    } // end constructor

    private Accessor readAccessor(Node node) {
        Accessor result = null;

        String accessorName = null;
        String accessorPermit = null;
        String accessorXPermits = null;
        String accessorLevels = null;
        String accessorIsAlias = null;
        String accessorIsSvc = null;
        NodeList accessorConfig = node.getChildNodes();
        for (int k = 0; k < accessorConfig.getLength(); k++) {
            Node param = accessorConfig.item(k);

            if (param.getNodeType() == Node.ELEMENT_NODE && ACCESSOR_NAME.equals(param.getNodeName())) {
                accessorName = param.getTextContent().replaceAll(REDUNDANT_XML_SYMBOLS, "").trim();
            }

            if (param.getNodeType() == Node.ELEMENT_NODE && ACCESSOR_PERMIT.equals(param.getNodeName())) {
                accessorPermit = param.getTextContent().replaceAll(REDUNDANT_XML_SYMBOLS, "").trim();
            }
            if (param.getNodeType() == Node.ELEMENT_NODE && ACCESSOR_XPERMITS.equals(param.getNodeName())) {
                accessorXPermits = param.getTextContent().replaceAll(REDUNDANT_XML_SYMBOLS, "").trim();
            }

            if (param.getNodeType() == Node.ELEMENT_NODE && ACCESSOR_LEVELS.equals(param.getNodeName())) {
                accessorLevels = param.getTextContent().replaceAll(REDUNDANT_XML_SYMBOLS, "").trim();
            }

            if (param.getNodeType() == Node.ELEMENT_NODE && ACCESSOR_IS_ALIAS.equals(param.getNodeName())) {
                accessorIsAlias = param.getTextContent().replaceAll(REDUNDANT_XML_SYMBOLS, "").trim();
            }

            if (param.getNodeType() == Node.ELEMENT_NODE && ACCESSOR_IS_SVC.equals(param.getNodeName())) {
                accessorIsSvc = param.getTextContent().replaceAll(REDUNDANT_XML_SYMBOLS, "").trim();
            }
        }

        if (accessorName != null && !accessorName.isEmpty()) {

            boolean accessorIsSvcB = false;
            if (accessorIsSvc != null && !accessorIsSvc.isEmpty()) {
                accessorIsSvcB = Boolean.parseBoolean(accessorIsSvc);
            }

            boolean accessorIsAliasB = false;
            if (accessorIsAlias != null && !accessorIsAlias.isEmpty()) {
                accessorIsAliasB = Boolean.parseBoolean(accessorIsAlias);
            }
            int accessorPermitI = 1;
            if (accessorPermit != null && !accessorPermit.isEmpty()) {
                accessorPermitI = Integer.parseInt(accessorPermit);
            }

            result = new Accessor(accessorName,
                    accessorIsAliasB,
                    accessorIsSvcB,
                    accessorPermitI,
                    accessorXPermits,
                    accessorLevels
//                    Splitter.on(",").trimResults().splitToList(accessorXPermits),
//                    Splitter.on(",").trimResults().splitToList(accessorLevels)
            );
        }

        return result;
    } // end readAccessor

    public Collection<Rule> getRules() {
        return rules;
    }

    public static void main(String[] args) {
        if (args.length > 0) {
            try {
                //----- READ ----------------------------------------------------------
                // Get a name of input file from first argument
                File in = new File(args[0]);
                // Read data from input file
                (new XmlDataProvider(in)).getRules().forEach(rule -> System.out.println(rule.getName()));
                //----- WRITE ---------------------------------------------------------
                // Get current date timestamp
//                SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMdd_HHmmss");
//                String formattedDate = simpleDateFormat.format(new Date());
                // Create a name for output file as a result of concatenation of source file's name and current time stamp
//                File out = new File(in.getParentFile(), FilenameUtils.getBaseName(in.getName()) + "_" + formattedDate + "." + FilenameUtils.getExtension(in.getName()));
                // Write data to output file
//                XmlDataProvider.newUploader(out).upload(data);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    } // end main
} // end XmlDataProvider

