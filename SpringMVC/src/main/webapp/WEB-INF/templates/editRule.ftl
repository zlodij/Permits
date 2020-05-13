<#import "container.ftl" as c>
<#assign sf=JspTaglibs["http://www.springframework.org/tags/form"]>
<@c.container>
    <@sf.form action="/rules/${id}/rule" method="post" modelAttribute="rule">
        <input id="rule_id" name="rule_id" type="hidden" value="${rule.getId()}"/>
        <div class="card">
            <h5 class="card-header">Rule : ${rule.getName()}</h5>
            <div class="card-body">
                <div class="form-group row">
                    <@sf.label cssClass="col-sm-2 col-form-label" path="name">Name</@sf.label>
                    <div class="col-sm-4">
                        <#--                        <input class="form-control <#if nameValidationMessage??>is-invalid<#else>is-valid</#if>"-->
                        <#--                               id="name" name="name" type="text" value="${rule.getName()}"-->
                        <#--                               placeholder="Enter rule name"/>-->
                        <@sf.input cssClass="form-control" path="name"/>
                        <#--                    </div>-->
                        <#--                    <div class="invalid-feedback">-->
                        <#if nameValidationMessage??>
                            <div class="alert alert-danger mt-1" role="alert">
                                ${nameValidationMessage}
                            </div>
                        </#if>
                    </div>
                </div>
                <div class="form-group row">
                    <@sf.label cssClass="col-sm-2 col-form-label" path="description">Description</@sf.label>
                    <div class="col-sm-4">
                        <@sf.input cssClass="form-control" path="description" />
                        <#--                        <input class="form-control" id="description" name="description" type="text"-->
                        <#--                               value="${rule.getDescription()}" placeholder="Enter rule description"/>-->
                        <#--                    </div>-->
                        <#if descriptionValidationMessage??>
                            <div class="alert alert-danger mt-1" role="alert">
                                ${descriptionValidationMessage}
                            </div>
                        </#if>
                    </div>
                </div>
                <div class="form-group row">
                    <@sf.label cssClass="col-sm-2 col-form-label" path="objTypes">Types</@sf.label>
                    <div class="col-sm-6">
                        <button class="btn btn-outline-primary btn-sm" type="button"
                                title="Edit"
                                onClick="location.href='/rules/${id}/rule/objTypes'">
                            <span class="fas fa-edit"></span>&nbsp;Edit
                        </button>
                        <div class="overflow-auto">${rule.getObjTypes()}</div>
                    </div>
                </div>
                <div class="form-group row">
                    <@sf.label cssClass="col-sm-2 col-form-label" path="statuses">Statuses</@sf.label>
                    <div class="col-sm-6">
                        <button class="btn btn-outline-primary btn-sm" type="button"
                                title="Edit"
                                onClick="location.href='/rules/${id}/rule/statuses'">
                            <span class="fas fa-edit"></span>&nbsp;Edit
                        </button>
                        <div class="overflow-auto">${rule.getStatuses()}</div>
                    </div>
                </div>
                <div class="form-group row">
                    <@sf.label cssClass="col-sm-2 col-form-label" path="accessors">Accessors</@sf.label>
                    <div class="col-sm-6">
                        <button class="btn btn-outline-primary btn-sm my-2" type="submit"
                                title="Add accessor"
                                formaction="/rules/${rule.getId()}/rule?addAccessor=true">
                            <span class="fas fa-plus"></span>&nbsp;Add
                        </button>
                        <#if rule.getAccessors()?has_content>
                            <div style="overflow: auto; width:850px; height:400px;border-style: solid; border-width: thin; border-color: lightgray">
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
                                            <td>${accessor.getPermitAsString()?upper_case}</td>
                                            <td>
                                                <#if accessor.isAlias()>
                                                    <span class="fas fa-check" style="color: green" title="Yes"></span>
                                                <#else>
                                                    <span class="fas fa-times" style="color: red" title="No"></span>
                                                </#if>
                                            </td>
                                            <td>
                                                <#if accessor.isSvc()>
                                                    <span class="fas fa-check" style="color: green" title="Yes"></span>
                                                <#else>
                                                    <span class="fas fa-times" style="color: red" title="No"></span>
                                                </#if>
                                            </td>
                                            <td>${accessor.getOrgLevels()}</td>
                                            <td>${accessor.getXPermitsAcronyms()}</td>
                                            <td>
                                                <button class="btn btn-outline-primary btn-sm" type="button"
                                                        title="Edit"
                                                        onClick="location.href='/rules/${accessor.getId()}/accessor?parentId=${accessor.getParentId()}'">
                                                    <span class="fas fa-edit"></span>
                                                </button>
                                            </td>
                                            <td>
                                                <button class="btn btn-outline-primary btn-sm" type="submit"
                                                        title="Delete"
                                                        formaction="/rules/${rule.getId()}/rule?deleteAccessor=${accessor.getId()}">
                                                    <span class="fas fa-trash"></span>
                                                </button>
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
                        <input class="btn btn-primary mr-2" name="apply" value="Apply" type="submit"/>
                        <input class="btn btn-primary mr-2" name="cancel" value="Cancel" title="Cancel" type="button"
                               onClick="location.href='/rules'"/>
                    </div>
                </div>
            </div>
        </div>
    </@sf.form>
</@c.container>
