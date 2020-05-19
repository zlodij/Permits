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
                                <select class="form-control" id="listRoles" onchange="onSelect(this)">
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
                                <select class="form-control" id="listSvcAliases" onchange="onSelect(this)">
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
                                <select class="form-control" id="listNotSvcAliases" onchange="onSelect(this)">
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
                    <div class="col-sm-3">
                        <#if listPermits?has_content>
                            <select class="form-control" id="permit" name="permit">
                                <#list listPermits as permit>
                                    <option value="${permit.getValue()}"
                                            <#if accessor.getPermit().equals(permit)>selected</#if>>${permit.getDisplay()?upper_case}</option>
                                </#list>
                            </select>
                        <#else>
                            <span>Not available</span>
                        </#if>
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
                        <#if listOrgLevels?has_content>
                            <select class="selectpicker" id="orgLevels" name="orgLevels" multiple
                                    <#if !(accessor.isAlias() && accessor.isSvc())>disabled</#if>>
                                <#list listOrgLevels as orgLevel>
                                    <option value="${orgLevel.getValue()}"
                                            <#if accessor.hasOrgLevel(orgLevel)>selected</#if>>${orgLevel.getDisplay()}</option>
                                </#list>
                            </select>
                        <#else>
                            <span>Not available</span>
                        </#if>
                        <div style="color:red;font-style:italic;">
                            <@sf.errors path="orgLevels"/>
                        </div>
                    </div>
                </div>
                <div class="form-group row">
                    <@sf.label cssClass="col-sm-2 col-form-label" path="xPermits">XPermits</@sf.label>
                    <div class="col-sm-4">
                        <#if listXPermits?has_content>
                            <select class="selectpicker" id="xPermits" name="xPermits" multiple>
                                <#list listXPermits as xPermit>
                                    <option value="${xPermit.getValue()}"
                                            <#if accessor.hasXPermit(xPermit)>selected</#if>>${xPermit.getDisplay()}</option>
                                </#list>
                            </select>
                        <#else>
                            <span>Not available</span>
                        </#if>
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
