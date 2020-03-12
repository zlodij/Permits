<!doctype html>
<#assign sf=JspTaglibs["http://www.springframework.org/tags/form"]>

<html>
<head>
</head>
<body>
<h2>New rule</h2>
<input name="home" value="Home" title="Home" type="button" onClick="location.href='/rules'"><br><br>

<@sf.form action="/rules/${id}/rule" method="post" modelAttribute="rule">
    <table border="0">
        <tr>
            <td valign="top">
                <table border="0">
                    <tr>
                        <td>
                            <@sf.label path="name">Name</@sf.label>
                        </td>
                        <td>
                            <@sf.input path="name"/>
                        </td>
                        <td>
                            <@sf.errors path="name"/>
                        <td>
                    </tr>
                    <tr>
                        <td>
                            <@sf.label path="description">Description</@sf.label>
                        </td>
                        <td>
                            <input id="name" name="description" type="text" value="${rule.getDescription()}"/>
                        </td>
                        <td>
                            <@sf.errors path="description"/>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <@sf.label path="objTypes">Types</@sf.label>
                        </td>
                        <td>
                            <@sf.select path="objTypes">
                                <@sf.option value="dm_folder" label="Folder"/>
                                <@sf.option value="dm_document" label="Document"/>
                            </@sf.select>
                        </td>
                        <td>
                            <@sf.errors path="objTypes"/>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <@sf.label path="statuses">Statuses</@sf.label>
                        </td>
                        <td>
                            <@sf.select path="statuses">
                                <@sf.option value="" label=""/>
                                <@sf.option value="ACTIVE" label="ACTIVE"/>
                                <@sf.option value="NEW" label="NEW"/>
                                <@sf.option value="PAUSED" label="PAUSED"/>
                            </@sf.select>
                        </td>
                        <td>
                            <@sf.errors path="statuses"/>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div>
                                <input type="submit">
                            </div>
                        </td>
                    </tr>
                </table>
            </td>
            <td valign="top">
                <div>
                    <table border="0">
                        <tr>
                            <td></td>
                            <td>
                                <table border="0">
                                    <tr>
                                        <td>
                                            <input name="add" value="Add" title="Add" type="button"/>
<#--                                            <button type="submit" formaction="/rules/${rule.getId()}/rule?accessor=true"-->
<#--                                                    formmethod="post">Add-->
<#--                                            </button>-->
                                        </td>
                                        <td>
                                            <input name="edit" value="Edit" title="Edit" type="button"/>
<#--                                            <button type="submit" formaction="/rules/${rule.getId()}/rule?accessor=true"-->
<#--                                                    formmethod="post">Edit-->
<#--                                            </button>-->
                                        </td>
                                        <td>
                                            <input name="remove" value="Remove" title="Remove" type="button"/>
<#--                                            <button typesubmit="" formaction="/rules/${rule.getId()}/rule?accessor=true"-->
<#--                                                    formmethod="post">Remove-->
<#--                                            </button>-->
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td><@sf.errors path="accessors"/></td>
                        </tr>
                        <tr>
                            <td><@sf.label path="accessors">Accessors</@sf.label></td>
                            <td>
                                <table border="0">
                                    <#if rule.getAccessors()?has_content>
                                        <#list rule.getAccessors() as accessor>
                                            <tr>
                                                <td>
                                                    <label><input class="radio" name="${rule.getName()}"
                                                                  id="${accessor.getName()}_checkbox"
                                                                  type="checkbox"
                                                                  title="${accessor.getName()}"/>${accessor.getName()}
                                                    </label>
                                                </td>
                                            </tr>
                                        </#list>
                                    <#else>
                                        <tr>
                                            <td><p>No accessors</p></td>
                                        </tr>
                                    </#if>
                                </table>
                            </td>
                            <td></td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
    </table>
</@sf.form>
</body>
</html>
