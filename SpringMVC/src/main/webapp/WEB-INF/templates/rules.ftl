<!doctype html>
<html>

<script language="JavaScript" type="text/javascript">
    function onEdit() {
        const rules = document.getElementById("listRules");
        if (rules.selectedIndex > 0) {
            location.href = '/rules/' + rules.options[rules.selectedIndex].value + '/rule';
        }
    }

    // Actualize value of result hidden field
    function onSelect(select) {
        // alert(select.selectedIndex)
        if (select.selectedIndex >= 0) {
            // alert(select.options[select.selectedIndex].value);
            document.getElementById("rule_id").value = select.options[select.selectedIndex].value;
            // alert(document.getElementById("rule_id").value);
        }
    } // end updateResultHidden
</script>

<body>
<h2>Permit rules
    <form action="/rules/delete" method="post">
        <table>
            <tr>
                <td>
                    <input id="rule_id" name="rule_id" type="hidden"/>
                    <#if rules?has_content>
                        <select id="listRules" onchange="onSelect(this)">
                            <option value="NONE">--- Select ---</option>
                            <#list rules as rule>
                                <option value="${rule.getId()}">${rule.name}</option>
                            </#list>
                        </select>
                    <#else>
                        <p>No rules</p>
                    </#if>
                </td>
            </tr>
            <tr>
                <td>
                    <table border="0">
                        <tr>
                            <td>
                                <input name="add" value="Add" title="Add" type="button"
                                       onClick="location.href='/rules/new'"/>
                            </td>
                            <td>
                                <input name="edit" value="Edit" title="Edit" type="button" onClick="onEdit()"/>
                            </td>
                            <td>
                                <input name="remove" value="Remove" title="Remove" type="submit"/>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
