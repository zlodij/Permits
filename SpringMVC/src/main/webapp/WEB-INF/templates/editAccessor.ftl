<!doctype html>
<#assign sf=JspTaglibs["http://www.springframework.org/tags/form"]>

<html>
<script language="JavaScript" type="text/javascript">
    // Actualize value of result hidden field
    function onSelect(select) {
        if (select.selectedIndex >= 0) {
            document.getElementById("name").value = select.options[select.selectedIndex].value;
        }
    } // end updateResultHidden

    function onClickAlias() {
        const checked = document.getElementById("alias").checked;
        document.getElementById("alias").value = checked;
        //alert(document.getElementById("alias").value);
        document.getElementById("div-role").hidden = checked;
        document.getElementById("div-alias").hidden = !checked;

        document.getElementById("svc").disabled = !checked;

        const select = checked ? document.getElementById("listAliases") : document.getElementById("listRoles");
        onSelect(select);
    } // end onClickAlias

    function onClickSvc() {
        const checked = document.getElementById("svc").checked;
        document.getElementById("svc").value = checked;
        const inputs = document.getElementsByName("orgLevels");

        let input;
        for (input of inputs) {
            input.disabled = !input.disabled;
        }
    } // end onClickSvc
</script>
<head>
</head>
<body>
<h2>New accessor</h2>
<table border="0">
    <@sf.form action="/rules/${accessor.getId()}/accessor" method="post" modelAttribute="accessor">
        <tr>
            <td>
                <div>
                    <input type="submit">
                    <input name="home" value="Cancel" title="Cancel" type="button"
                           onClick="location.href='/rules/${accessor.getParentId()}/rule'">
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <@sf.label path="name">Name</@sf.label>
            </td>
            <td>
                <@sf.hidden path="id"/>
                <@sf.hidden path="parentId"/>
                <@sf.hidden path="name"/>
                <div id="div-role" <#if accessor.isAlias()>hidden</#if>>
                    <#if listRoles?has_content>
                        <select id="listRoles" onchange="onSelect(this)">
                            <option value=""/>
                            <#list listRoles as role>
                                <option value="${role}" <#if role == accessor.name>selected</#if>>${role}</option>
                            </#list>
                        </select>
                    <#else>
                        <p>No roles available</p>
                    </#if>
                </div>
                <#--                <div id="div-role" hidden="${accessor.isAlias()?c}">-->
                <div id="div-alias" <#if !accessor.isAlias()>hidden</#if>>
                    <#if listAliases?has_content>
                        <select id="listAliases" onchange="onSelect(this)">
                            <option value=""/>
                            <#list listAliases as alias>
                                <option value="${alias}" <#if alias == accessor.name>selected</#if>>${alias}</option>
                            </#list>
                        </select>
                    <#else>
                        <p>No aliases available</p>
                    </#if>
                </div>
            </td>
            <td>
                <div style="color:red;font-style:italic;">
                    <@sf.errors path="name"/>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <@sf.label path="permit">Permit</@sf.label>
            </td>
            <td>
                <@sf.select path="permit">
                    <@sf.option value="0" label=""/>
                    <@sf.option value="1" label="NONE"/>
                    <@sf.option value="2" label="BROWSE"/>
                    <@sf.option value="3" label="READ"/>
                    <@sf.option value="4" label="RELATE"/>
                    <@sf.option value="5" label="VERSION"/>
                    <@sf.option value="6" label="WRITE"/>
                    <@sf.option value="7" label="DELETE"/>
                </@sf.select>
            </td>
            <td>
                <div style="color:red;font-style:italic;">
                    <@sf.errors path="permit"/>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <@sf.label path="alias">Alias</@sf.label>
            </td>
            <td>
                <input id="alias" name="alias" value="${accessor.isAlias()?c}" title="Is Alias?" type="checkbox"
                       onclick="onClickAlias()"
                       <#if accessor.isAlias()>checked</#if>/>
            </td>
            <td>
                <div style="color:red;font-style:italic;">
                    <@sf.errors path="alias"/>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <@sf.label path="svc">Service</@sf.label>
            </td>
            <td>
                <input id="svc" name="svc" value="${accessor.isSvc()?c}" title="Is Service?" type="checkbox"
                       onclick="onClickSvc()"
                       <#if accessor.isSvc()>checked</#if> <#if !accessor.isAlias()>disabled</#if>/>
            </td>
            <td>
                <div style="color:red;font-style:italic;">
                    <@sf.errors path="svc"/>
                </div>
            </td>
        </tr>
        <tr>
            <td colspan="3">
                <hr>
            </td>
        </tr>
        <tr>
            <td>
                <@sf.label path="orgLevels">Org.Levels</@sf.label>
            </td>
            <td>
                <label><input name="orgLevels" value="co" title="CO" type="checkbox"
                              <#if accessor.getOrgLevels()?contains("co")>checked</#if>
                            <#if !(accessor.isAlias() && accessor.isSvc())>disabled</#if>/>Central Office
                    (CO)</label><br>
                <label><input name="orgLevels" value="vr" title="VR" type="checkbox"
                              <#if accessor.getOrgLevels()?contains("vr")>checked</#if>
                            <#if !(accessor.isAlias() && accessor.isSvc())>disabled</#if>/>Super Region (VR)</label><br>
                <label><input name="orgLevels" value="mr" title="MR" type="checkbox"
                              <#if accessor.getOrgLevels()?contains("mr")>checked</#if>
                            <#if !(accessor.isAlias() && accessor.isSvc())>disabled</#if>/>Macro Region (MR)</label><br>
                <label><input name="orgLevels" value="od" title="OD" type="checkbox"
                              <#if accessor.getOrgLevels()?contains("od")>checked</#if>
                            <#if !(accessor.isAlias() && accessor.isSvc())>disabled</#if>/>Outstanding Direction
                    (OD)</label><br>
                <label><input name="orgLevels" value="rd" title="RD" type="checkbox"
                              <#if accessor.getOrgLevels()?contains("rd")>checked</#if>
                            <#if !(accessor.isAlias() && accessor.isSvc())>disabled</#if>/>Regional Direction
                    (RD)</label><br>
            </td>
            <td>
                <div style="color:red;font-style:italic;">
                    <@sf.errors path="orgLevels"/>
                </div>
            </td>
        </tr>
        <tr>
            <td colspan="3">
                <hr>
            </td>
        </tr>
        <tr>
            <td>
                <@sf.label path="xPermits">XPermits</@sf.label>
            </td>
            <td>
                <label><input name="xPermits" value="EXECUTE_PROC" title="Execute Procedure" type="checkbox"
                              <#if accessor.getXPermits()?contains("EXECUTE_PROC")>checked</#if>/>Execute Procedure (EP)</label><br>
                <label><input name="xPermits" value="CHANGE_LOCATION" title="Change Location" type="checkbox"
                              <#if accessor.getXPermits()?contains("CHANGE_LOCATION")>checked</#if>/>Change Location
                    (CL)</label><br>
                <label><input name="xPermits" value="CHANGE_STATE" title="Change State" type="checkbox"
                              <#if accessor.getXPermits()?contains("CHANGE_STATE")>checked</#if>/>Change State
                    (CS)</label><br>
                <label><input name="xPermits" value="CHANGE_PERMIT" title="Change Permission" type="checkbox"
                              <#if accessor.getXPermits()?contains("CHANGE_PERMIT")>checked</#if>/>Change Permission
                    (CP)</label><br>
                <label><input name="xPermits" value="CHANGE_OWNER" title="Change Ownership" type="checkbox"
                              <#if accessor.getXPermits()?contains("CHANGE_OWNER")>checked</#if>/>Change Ownership (CO)</label><br>
                <label><input name="xPermits" value="DELETE_OBJECT" title="Extended Delete" type="checkbox"
                              <#if accessor.getXPermits()?contains("DELETE_OBJECT")>checked</#if>/>Extended Delete (DO)</label><br>
                <label><input name="xPermits" value="CHANGE_FOLDER_LINKS" title="Change Folder Links" type="checkbox"
                              <#if accessor.getXPermits()?contains("CHANGE_FOLDER_LINKS")>checked</#if>/>Change Folder
                    Links (CFL)</label><br>
            </td>
            <td>
                <div style="color:red;font-style:italic;">
                    <@sf.errors path="xPermits"/>
                </div>
            </td>
        </tr>
    </@sf.form>
</table>
</body>
</html>
