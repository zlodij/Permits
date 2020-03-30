<!doctype html>
<html>

<script language="JavaScript" type="text/javascript">
    function onEdit() {
        const rules = document.getElementById("listRules");
        if (rules.selectedIndex > 0) {
            location.href = '/rules/' + rules.options[rules.selectedIndex].value + '/rule';
        }
    }
</script>

<body>
<h2>Permit rules</h2>
<table>
    <tr>
        <td>
            <#if rules?has_content>
                <select id="listRules">
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
                               onClick="location.href='/rules/new'">
                    </td>
                    <td>
                        <input name="edit" value="Edit" title="Edit" type="button" onClick="javascript:onEdit()">
                    </td>
                    <td>
                        <#--                        <input name="remove" value="Remove" title="Remove" type="button"-->
                        <#--                               onClick="location.href='/rules/new/rule'">-->
                        <input name="remove" value="Remove" title="Remove" type="button">
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</body>
</html>
