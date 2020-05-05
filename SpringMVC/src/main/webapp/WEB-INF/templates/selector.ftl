<#import "container.ftl" as c>
<#assign sf=JspTaglibs["http://www.springframework.org/tags/form"]>
<@c.container>
    <script type="text/javascript">
        // Actualize value of result hidden field
        function updateHiddenFromSelect(select) {
            let value = "";
            let option;
            for (option of select) {
                if (value.length > 0) value += ",";
                value += option.value;
            }

            document.getElementById("selected").value = value;
        } // end updateResultHidden

        // Moves selected options from left select to right
        function onAdd() {
            const listIn = document.getElementById("listIn");
            const listOut = document.getElementById("listOut");

            copySelectedOptions(listIn, listOut);

            updateHiddenFromSelect(listOut);
        } // end onAdd

        // Removes selected options from right select to left
        function onRemove() {
            const listIn = document.getElementById("listIn");
            const listOut = document.getElementById("listOut");

            copySelectedOptions(listOut, listIn);

            updateHiddenFromSelect(listOut);
        } // end onRemove

        // Copies selected options from input select to output
        function copySelectedOptions(input, output) {
            const selected = getSelectOptions(input);

            let option;
            for (option of selected) {
                option.selected = false;
                output.appendChild(option);
            }
        } // end copySelectedOptions

        // Return an array of selected options
        function getSelectOptions(select) {
            const result = [];

            let option;
            for (option of select.options) {
                if (option.selected) {
                    result.push(option);
                }
            }

            return result;
        } // end getSelectValues
    </script>
    <@sf.form action="/rules/${id}/rule/selector" method="post">
        <input id="attribute" name="attribute" type="hidden" value="${attribute}"/>
        <input id="selected" name="selected" type="hidden" value="${listSelected?join(",")}"/>
        <div class="card w-50">
            <h5 class="card-header">Choose : ${title}</h5>
            <div class="card-body">
                <div class="form-group row">
                    <table>
                        <tr>
                            <td>
                                <select multiple class="form-control" id="listIn" name="listIn">
                                    <#if listAvailable?has_content>
                                        <#list listAvailable as row>
                                            <option value="${row}">${row}</option>
                                        </#list>
                                    <#else>
                                        <option value=""></option>
                                    </#if>
                                </select>
                            </td>
                            <td>
                                <table>
                                    <tr>
                                        <td>
                                            <button class="btn btn-outline-primary btn-sm mx-3" type="button"
                                                    onclick="onAdd()">&gt;
                                            </button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <button class="btn btn-outline-primary btn-sm mx-3" type="button"
                                                    onclick="onRemove()">&lt;
                                            </button>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td>
                                <select multiple class="form-control" id="listOut" name="listOut">
                                    <#if listSelected?has_content>
                                        <#list listSelected as row>
                                            <option value="${row}">${row}</option>
                                        </#list>
                                    </#if>
                                </select>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="form-group row">
                    <input class="btn btn-primary mx-2" name="apply" value="Apply" type="submit"/>
                    <input class="btn btn-primary mx-2" name="cancel" value="Cancel" title="Cancel" type="button"
                           onClick="location.href='/rules/${id}/rule'">
                </div>
            </div>
        </div>
    </@sf.form>
</@c.container>