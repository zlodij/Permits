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
            document.getElementById("orgLevels").disabled = !isSvcChecked;

            const select = isSvcChecked
                ? document.getElementById("listSvcAliases")
                : document.getElementById("listNotSvcAliases");
            onSelect(select);
        } // end onClickSvc
    </script>
    <@sf.form action="/rules/${accessor.getId()}/accessor" method="post" modelAttribute="accessor">
        <@sf.hidden path="id"/>
        <@sf.hidden path="parentId"/>
        <@sf.hidden path="name"/>
        <div class="card w-75">
            <h5 class="card-header">Accessor : ${accessor.getName()}</h5>
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
                        <div style="color:red;font-style:italic;">
                            <@sf.errors path="name"/>
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
                        <select class="selectpicker" id="orgLevels" name="orgLevels" multiple
                                <#if !(accessor.isAlias() && accessor.isSvc())>disabled</#if>>
                            <option value="co" <#if accessor.getOrgLevels()?contains("co")>selected</#if>>Central Office
                                (CO)
                            </option>
                            <option value="vr" <#if accessor.getOrgLevels()?contains("vr")>selected</#if>>Super Region
                                (VR)
                            </option>
                            <option value="mr" <#if accessor.getOrgLevels()?contains("mr")>selected</#if>>Macro Region
                                (MR)
                            </option>
                            <option value="od" <#if accessor.getOrgLevels()?contains("od")>selected</#if>>Outstanding
                                Direction (OD)
                            </option>
                            <option value="rd" <#if accessor.getOrgLevels()?contains("rd")>selected</#if>>Regional
                                Direction (RD)
                            </option>
                        </select>
                        <script type="text/javascript">
                            $('orgLevels').selectpicker();
                        </script>
                        <div style="color:red;font-style:italic;">
                            <@sf.errors path="orgLevels"/>
                        </div>
                    </div>
                </div>
                <div class="form-group row">
                    <@sf.label cssClass="col-sm-2 col-form-label" path="xPermits">XPermits</@sf.label>
                    <div class="col-sm-4">
                        <select class="selectpicker" id="xPermits" name="xPermits" multiple>
                            <option value="EXECUTE_PROC"
                                    <#if accessor.getXPermits()?contains("EXECUTE_PROC")>selected</#if>>Execute
                                Procedure (EP)
                            </option>
                            <option value="CHANGE_LOCATION"
                                    <#if accessor.getXPermits()?contains("CHANGE_LOCATION")>selected</#if>>Change
                                Location (CL)
                            </option>
                            <option value="CHANGE_STATE"
                                    <#if accessor.getXPermits()?contains("CHANGE_STATE")>selected</#if>>Change State
                                (CS)
                            </option>
                            <option value="CHANGE_PERMIT"
                                    <#if accessor.getXPermits()?contains("CHANGE_PERMIT")>selected</#if>>Change
                                Permission (CP)
                            </option>
                            <option value="CHANGE_OWNER"
                                    <#if accessor.getXPermits()?contains("CHANGE_OWNER")>selected</#if>>Change Ownership
                                (CO)
                            </option>
                            <option value="DELETE_OBJECT"
                                    <#if accessor.getXPermits()?contains("DELETE_OBJECT")>selected</#if>>Extended Delete
                                (DO)
                            </option>
                            <option value="CHANGE_FOLDER_LINKS"
                                    <#if accessor.getXPermits()?contains("CHANGE_FOLDER_LINKS")>selected</#if>>Change
                                Folder Links (CFL)
                            </option>
                        </select>
                        <script type="text/javascript">
                            $('xPermits').selectpicker();
                        </script>
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
