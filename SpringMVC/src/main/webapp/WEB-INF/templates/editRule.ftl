<#import "container.ftl" as c>
<#assign sf=JspTaglibs["http://www.springframework.org/tags/form"]>
<@c.container>
    <@sf.form action="/rules/${id}/rule" method="post" modelAttribute="rule">
        <input id="rule_id" name="rule_id" type="hidden" value="${rule.getId()}"/>
        <div class="card">
            <h5 class="card-header">Edit Rule : ${rule.getName()}</h5>
            <div class="card-body">
                <div class="form-group row">
                    <@sf.label cssClass="col-sm-2 col-form-label" path="name">Name</@sf.label>
                    <div class="col-sm-4">
                        <@sf.input path="name" cssClass="form-control"/>
                    </div>
                    <#if nameValidationMessage??>
                    <#--                        <div class="alert alert-danger" role="alert">-->
                        ${nameValidationMessage}
                    <#--                        </div>-->
                    </#if>
                </div>
                <div class="form-group row">
                    <@sf.label cssClass="col-sm-2 col-form-label" path="description">Description</@sf.label>
                    <div class="col-sm-4">
                        <@sf.input path="description" cssClass="form-control"/>
                    </div>
                    <#if descriptionValidationMessage??>
                    <#--                        <div class="alert alert-danger" role="alert">-->
                        ${descriptionValidationMessage}
                    <#--                        </div>-->
                    </#if>
                </div>
                <div class="form-group row">
                    <@sf.label cssClass="col-sm-2 col-form-label" path="objTypes">Types</@sf.label>
                    <div class="col-sm-6">
                        <a class="btn btn-outline-primary btn-sm"
                           href="/rules/${id}/rule/objTypes">Edit</a>&nbsp;
                        <div class="overflow-auto">${rule.getObjTypes()}</div>
                    </div>
                </div>
                <div class="form-group row">
                    <@sf.label cssClass="col-sm-2 col-form-label" path="statuses">Statuses</@sf.label>
                    <div class="col-sm-6">
                        <a class="btn btn-outline-primary btn-sm"
                           href="/rules/${id}/rule/statuses">Edit</a>&nbsp;${rule.getStatuses()}
                    </div>
                </div>
                <div class="form-group row">
                    <@sf.label cssClass="col-sm-2 col-form-label" path="accessors">Accessors</@sf.label>
                    <div class="col-sm-6">
                        <input class="btn btn-outline-primary btn-sm mb-2" name="add"
                               formaction="/rules/${rule.getId()}/rule?addAccessor=true" value="Add" type="submit"/>
                        <#if rule.getAccessors()?has_content>
                            <div style="overflow: auto; width:1000px; height:400px;border-style: solid; border-width: thin; border-color: lightgray">
                                <table class="table table-striped">
                                    <thead>
                                    <tr>
                                        <th scope="col">Name</th>
                                        <th scope="col">Permit</th>
                                        <th scope="col">Alias</th>
                                        <th scope="col">Svc</th>
                                        <th scope="col">Org.Levels</th>
                                        <th scope="col">XPermits</th>
                                        <th scope="col"></th>
                                        <th scope="col"></th>
                                    </tr>
                                    </thead>
                                    <tbody>
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
                                            <td><input class="btn btn-outline-primary btn-sm"
                                                       name="add_${accessor.getId()}"
                                                       value="Edit" title="Edit" type="button"
                                                       onClick="location.href='/rules/${accessor.getId()}/accessor?parentId=${accessor.getParentId()}'">
                                            </td>
                                            <td><input class="btn btn-outline-primary btn-sm"
                                                       name="delete_${accessor.getId()}"
                                                       value="Delete" title="Delete" type="submit"
                                                       formaction="/rules/${rule.getId()}/rule?deleteAccessor=${accessor.getId()}">
                                            </td>
                                        </tr>
                                    </#list>
                                    </tbody>
                                </table>
                            </div>
                        <#else>
                            <span>No accessors</span>
                        </#if>
                    </div>
                </div>
                <div class="form-group row">
                    <div class="col-sm-2"></div>
                    <div class="col-sm-4">
                        <input class="btn btn-primary mx-2" name="apply" value="Apply" type="submit"/>
                        <input class="btn btn-primary mx-2" name="cancel" value="Cancel" title="Cancel" type="button"
                               onClick="location.href='/rules'"/>
                    </div>
                </div>
            </div>
        </div>
    </@sf.form>
</@c.container>
