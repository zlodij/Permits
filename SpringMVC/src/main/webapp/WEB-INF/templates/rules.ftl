<#import "container.ftl" as c>
<@c.container>
    <script type="text/javascript">
        function onEdit() {
            const rules = document.getElementById("listRules");
            if (rules.selectedIndex > 0) {
                location.href = '/rules/' + rules.options[rules.selectedIndex].value + '/rule';
            }
        }

        // Actualize value of result hidden field
        function onSelect(select) {
            if (select.selectedIndex >= 0) {
                document.getElementById("rule_id").value = select.options[select.selectedIndex].value;
            }
        } // end updateResultHidden
    </script>
    <form action="/rules/delete" method="post">
        <div class="card w-50">
            <h5 class="card-header">Rules</h5>
            <div class="card-body">
                <div class="form-group row">
                    <input id="rule_id" name="rule_id" type="hidden"/>
                    <div class="col-sm-1"></div>
                    <div class="col-sm-10">
                        <#if rules?has_content>
                            <select class="form-control-sm" id="listRules" onchange="onSelect(this)">
                                <option value="NONE">--- Select ---</option>
                                <#list rules as rule>
                                    <option value="${rule.getId()}">${rule.name}</option>
                                </#list>
                            </select>
                        <#else>
                            <p>No rules</p>
                        </#if>
                    </div>
                </div>
                <div class="form-group row">
                    <div class="col-sm-1"></div>
                    <div class="col-sm-10">
                        <input class="btn btn-primary mr-2" name="add" value="Add" title="Add" type="button"
                               onClick="location.href='/rules/new'"/>
                        <input class="btn btn-primary mr-2" name="edit"
                               value="Edit" title="Edit" type="button" onClick="onEdit()"/>
                        <input class="btn btn-primary" name="remove" value="Remove" title="Remove" type="submit"/>
                    </div>
                </div>
            </div>
        </div>
    </form>
</@c.container>
