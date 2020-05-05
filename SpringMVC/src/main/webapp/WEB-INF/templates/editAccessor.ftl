<#import "container.ftl" as c>
<#assign sf=JspTaglibs["http://www.springframework.org/tags/form"]>
<@c.container>
    <script type="text/javascript">
        // Actualize value of result hidden field
        function onSelect(select) {
            if (select.selectedIndex >= 0) {
                document.getElementById("name").value = select.options[select.selectedIndex].value;
            }
        } // end updateResultHidden

        function onClickAlias() {
            const isAliasChecked = document.getElementById("alias").checked;
            const isSvcChecked = document.getElementById("svc").checked;
            document.getElementById("alias").value = isAliasChecked;
            document.getElementById("div-role").hidden = isAliasChecked;
            document.getElementById("div-svc-alias").hidden = !isAliasChecked || !isSvcChecked;
            document.getElementById("div-not-svc-alias").hidden = !isAliasChecked || isSvcChecked;

            document.getElementById("svc").disabled = !isAliasChecked;

            const select = !isAliasChecked
                ? document.getElementById("listRoles")
                : (isSvcChecked
                        ? document.getElementById("listSvcAliases")
                        : document.getElementById("listNotSvcAliases")
                );
            onSelect(select);
        } // end onClickAlias

        function onClickSvc() {
            const isSvcChecked = document.getElementById("svc").checked;
            document.getElementById("svc").value = isSvcChecked;
            document.getElementById("div-svc-alias").hidden = !isSvcChecked;
            document.getElementById("div-not-svc-alias").hidden = isSvcChecked;

            const select = isSvcChecked
                ? document.getElementById("listSvcAliases")
                : document.getElementById("listNotSvcAliases");
            onSelect(select);

            const inputs = document.getElementsByName("orgLevels");

            let input;
            for (input of inputs) {
                input.disabled = !input.disabled;
            }
        } // end onClickSvc
    </script>
    <@sf.form action="/rules/${accessor.getId()}/accessor" method="post" modelAttribute="accessor">
        <@sf.hidden path="id"/>
        <@sf.hidden path="parentId"/>
        <@sf.hidden path="name"/>
        <div class="card">
            <h5 class="card-header">Edit Accessor : ${accessor.getName()}</h5>
            <div class="card-body">
                <div class="form-group row">
                    <@sf.label cssClass="col-sm-2 col-form-label" path="name">Name</@sf.label>
                    <div class="col-sm-4">
                        <div id="div-role" <#if accessor.isAlias()>hidden</#if>>
                            <#if listRoles?has_content>
                                <select class="form-control-sm" id="listRoles" onchange="onSelect(this)">
                                    <option value=""/>
                                    <#list listRoles as role>
                                        <option value="${role}"
                                                <#if role == accessor.name>selected</#if>>${role}</option>
                                    </#list>
                                </select>
                            <#else>
                                <p>No roles available</p>
                            </#if>
                        </div>
                        <div id="div-svc-alias" <#if !accessor.isAlias() || !accessor.isSvc()>hidden</#if>>
                            <#if listSvcAliases?has_content>
                                <select class="form-control-sm" id="listSvcAliases" onchange="onSelect(this)">
                                    <option value=""/>
                                    <#list listSvcAliases as alias>
                                        <option value="${alias}"
                                                <#if alias == accessor.name>selected</#if>>${alias}</option>
                                    </#list>
                                </select>
                            <#else>
                                <p>No aliases available</p>
                            </#if>
                        </div>
                        <div id="div-not-svc-alias" <#if !accessor.isAlias() || accessor.isSvc()>hidden</#if>>
                            <#if listNotSvcAliases?has_content>
                                <select class="form-control-sm" id="listNotSvcAliases" onchange="onSelect(this)">
                                    <option value=""/>
                                    <#list listNotSvcAliases as alias>
                                        <option value="${alias}"
                                                <#if alias == accessor.name>selected</#if>>${alias}</option>
                                    </#list>
                                </select>
                            <#else>
                                <p>No aliases available</p>
                            </#if>
                        </div>
                        <div class="alert alert-danger" role="alert">
                            <@sf.errors path="permit"/>
                        </div>
                    </div>
                </div>
                <div class="form-group row">
                    <@sf.label cssClass="col-sm-2 col-form-label" path="permit">Permit</@sf.label>
                    <div class="col-sm-4">
                        <@sf.select cssClass="form-control-sm" path="permit">
                            <@sf.option value="0" label=""/>
                            <@sf.option value="1" label="NONE"/>
                            <@sf.option value="2" label="BROWSE"/>
                            <@sf.option value="3" label="READ"/>
                            <@sf.option value="4" label="RELATE"/>
                            <@sf.option value="5" label="VERSION"/>
                            <@sf.option value="6" label="WRITE"/>
                            <@sf.option value="7" label="DELETE"/>
                        </@sf.select>
                        <div style="color:red;font-style:italic;">
                            <@sf.errors path="permit"/>
                        </div>
                    </div>
                </div>
                <div class="form-group row">
                    <@sf.label cssClass="col-sm-2 col-form-label" path="alias">Alias</@sf.label>
                    <div class="col-sm-4">
                        <div class="form-check">
                            <input class="form-check-input position-static" id="alias" name="alias"
                                   value="${accessor.isAlias()?c}" title="Is Alias?" type="checkbox"
                                   onclick="onClickAlias()"
                                   <#if accessor.isAlias()>checked</#if> aria-label="Is Alias?"/>
                        </div>
                        <div style="color:red;font-style:italic;">
                            <@sf.errors path="alias"/>
                        </div>
                    </div>
                </div>
                <div class="form-group row">
                    <@sf.label cssClass="col-sm-2 col-form-label" path="svc">Service</@sf.label>
                    <div class="col-sm-4">
                        <input id="svc" name="svc" value="${accessor.isSvc()?c}" title="Is Service?" type="checkbox"
                               onclick="onClickSvc()"
                               <#if accessor.isSvc()>checked</#if> <#if !accessor.isAlias()>disabled</#if>/>
                        <div style="color:red;font-style:italic;">
                            <@sf.errors path="svc"/>
                        </div>
                    </div>
                </div>
                <div class="form-group row">
                    <@sf.label cssClass="col-sm-2 col-form-label" path="orgLevels">Org.Levels</@sf.label>
                    <div class="col-sm-4">
                        <div class="form-check mb-2">
                            <input class="form-check-input" name="orgLevels" value="co" title="CO" type="checkbox"
                                   <#if accessor.getOrgLevels()?contains("co")>checked</#if>
                                    <#if !(accessor.isAlias() && accessor.isSvc())>disabled</#if>/>
                            <label class="form-check-label">Central Office (CO)</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input" name="orgLevels" value="vr" title="VR" type="checkbox"
                                   <#if accessor.getOrgLevels()?contains("vr")>checked</#if>
                                    <#if !(accessor.isAlias() && accessor.isSvc())>disabled</#if>/>
                            <label class="form-check-label">Super Region (VR)</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input" name="orgLevels" value="mr" title="MR" type="checkbox"
                                   <#if accessor.getOrgLevels()?contains("mr")>checked</#if>
                                    <#if !(accessor.isAlias() && accessor.isSvc())>disabled</#if>/>
                            <label class="form-check-label">Macro Region (MR)</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input" name="orgLevels" value="od" title="OD" type="checkbox"
                                   <#if accessor.getOrgLevels()?contains("od")>checked</#if>
                                    <#if !(accessor.isAlias() && accessor.isSvc())>disabled</#if>/>
                            <label class="form-check-label">Outstanding Direction (OD)</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input" name="orgLevels" value="rd" title="RD" type="checkbox"
                                   <#if accessor.getOrgLevels()?contains("rd")>checked</#if>
                                    <#if !(accessor.isAlias() && accessor.isSvc())>disabled</#if>/>
                            <label class="form-check-label">Regional Direction (RD)</label>
                        </div>
                        <div style="color:red;font-style:italic;">
                            <@sf.errors path="orgLevels"/>
                        </div>
                    </div>
                </div>
                <div class="form-group row">
                    <@sf.label cssClass="col-sm-2 col-form-label" path="xPermits">XPermits</@sf.label>
                    <div class="col-sm-4">
                        <div class="form-check mb-2">
                            <input class="form-check-input" name="xPermits" value="EXECUTE_PROC"
                                   title="Execute Procedure"
                                   type="checkbox" <#if accessor.getXPermits()?contains("EXECUTE_PROC")>checked</#if>/>
                            <label class="form-check-label">Execute Procedure (EP)</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input" name="xPermits" value="CHANGE_LOCATION"
                                   title="Change Location"
                                   type="checkbox"
                                   <#if accessor.getXPermits()?contains("CHANGE_LOCATION")>checked</#if>/>
                            <label class="form-check-label">Change Location (CL)</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input" name="xPermits" value="CHANGE_STATE" title="Change State"
                                   type="checkbox" <#if accessor.getXPermits()?contains("CHANGE_STATE")>checked</#if>/>
                            <label class="form-check-label">Change State (CS)</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input" name="xPermits" value="CHANGE_PERMIT"
                                   title="Change Permission"
                                   type="checkbox" <#if accessor.getXPermits()?contains("CHANGE_PERMIT")>checked</#if>/>
                            <label class="form-check-label">Change Permission (CP)</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input" name="xPermits" value="CHANGE_OWNER"
                                   title="Change Ownership"
                                   type="checkbox" <#if accessor.getXPermits()?contains("CHANGE_OWNER")>checked</#if>/>
                            <label class="form-check-label">Change Ownership (CO)</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input" name="xPermits" value="DELETE_OBJECT"
                                   title="Extended Delete"
                                   type="checkbox" <#if accessor.getXPermits()?contains("DELETE_OBJECT")>checked</#if>/>
                            <label class="form-check-label">Extended Delete (DO)</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input" name="xPermits" value="CHANGE_FOLDER_LINKS"
                                   title="Change Folder Links" type="checkbox"
                                   <#if accessor.getXPermits()?contains("CHANGE_FOLDER_LINKS")>checked</#if>/>
                            <label class="form-check-label">Change Folder Links (CFL)</label>
                        </div>
                        <div style="color:red;font-style:italic;">
                            <@sf.errors path="xPermits"/>
                        </div>
                    </div>
                </div>
                <div class="form-group row">
                    <div class="col-sm-2"></div>
                    <div class="col-sm-4">
                        <input class="btn btn-primary mx-2" name="apply" value="Apply" type="submit"/>
                        <input class="btn btn-primary mx-2" name="cancel" value="Cancel" title="Cancel" type="button"
                               onClick="location.href='/rules/${accessor.getParentId()}/rule'">
                    </div>
                </div>
            </div>
        </div>
    </@sf.form>
</@c.container>
