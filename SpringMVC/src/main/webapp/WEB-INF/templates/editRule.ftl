<#import "container.ftl" as c>
<#assign sf=JspTaglibs["http://www.springframework.org/tags/form"]>
<@c.container "Edit Rule">
    <@sf.form action="/rules/${id}/rule" method="post" modelAttribute="rule">
        <table>
            <tr>
                <td style="vertical-align:top;">
                    <table>
                        <tr>
                            <td>
                                <div>
                                    <input type="submit">
                                    <input name="home" value="Cancel" title="Cancel" type="button"
                                           onClick="location.href='/rules'">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <@sf.label path="name">Name</@sf.label>
                            </td>
                            <td>
                                <input id="rule_id" name="rule_id" type="hidden" value="${rule.getId()}"/>
                                <@sf.input path="name"/>
                            </td>
                            <td style="width: auto;">
                                <#if nameValidationMessage??>
                                    <div style="color:red;font-style:italic;">
                                        ${nameValidationMessage}
                                    </div>
                                </#if>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <@sf.label path="description">Description</@sf.label>
                            </td>
                            <td>
                                <input id="name" name="description" type="text" value="${rule.getDescription()}"/>
                            </td>
                            <td>
                                <#if descriptionValidationMessage??>
                                    <div style="color:red;font-style:italic;">
                                        ${descriptionValidationMessage}
                                    </div>
                                </#if>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <@sf.label path="objTypes">Types</@sf.label>
                            </td>
                            <td>
                                <a href="/rules/${id}/rule/objTypes">Edit</a>&nbsp;${rule.getObjTypes()}
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <@sf.label path="statuses">Statuses</@sf.label>
                            </td>
                            <td>
                                <a href="/rules/${id}/rule/statuses">Edit</a>&nbsp;${rule.getStatuses()}
                            </td>
                        </tr>
                        <tr>
                            <td style="vertical-align:top;">
                                <@sf.label path="accessors">Accessors</@sf.label>
                                <button type="submit" formaction="/rules/${rule.getId()}/rule?addAccessor=true"
                                        formmethod="post">Add
                                </button>
                            </td>
                            <#if rule.getAccessors()?has_content>
                                <td colspan="2">
                                    <div style="overflow: auto; width:900px; height:400px;border-style: solid; border-width: thin; border-color: lightgray">
                                        <table>
                                            <tbody>
                                            <tr>
                                                <th>
                                                    Name
                                                </th>
                                                <th>
                                                    Permit
                                                </th>
                                                <th>
                                                    Alias
                                                </th>
                                                <th>
                                                    Svc
                                                </th>
                                                <th>
                                                    Org.Levels
                                                </th>
                                                <th>
                                                    XPermits
                                                </th>
                                                <th></th>
                                                <th></th>
                                            </tr>
                                            <#list rule.getAccessors() as accessor>
                                                <tr>
                                                    <td>${accessor.getName()}</td>
                                                    <td>${accessor.getPermit()}</td>
                                                    <td><label><input class="radio"
                                                                      name="${accessor.getId()}_isAlias"
                                                                      id="${accessor.getId()}_isAlias"
                                                                      type="checkbox" disabled
                                                                      <#if accessor.isAlias()>checked</#if>/>
                                                        </label>
                                                    </td>
                                                    <td><label><input class="radio"
                                                                      name="${accessor.getId()}_isSvc"
                                                                      id="${accessor.getId()}_isSvc"
                                                                      type="checkbox" disabled
                                                                      <#if accessor.isSvc()>checked</#if>/>
                                                        </label>
                                                    </td>
                                                    <td>${accessor.getOrgLevels()?upper_case}</td>
                                                    <td>${accessor.getXPermits()}</td>
                                                    <td><input name="add_${accessor.getId()}" value="Edit" title="Edit"
                                                               type="button"
                                                               onClick="location.href='/rules/${accessor.getId()}/accessor?parentId=${accessor.getParentId()}'">
                                                    </td>
                                                    <td><input name="delete_${accessor.getId()}" value="Delete"
                                                               title="Delete" type="submit"
                                                               formaction="/rules/${rule.getId()}/rule?deleteAccessor=${accessor.getId()}">
                                                    </td>
                                                </tr>
                                            </#list>
                                            </tbody>
                                        </table>
                                    </div>
                                </td>
                            <#else>
                                <td style="vertical-align:top;">No accessors</td>
                            </#if>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </@sf.form>
</@c.container>
