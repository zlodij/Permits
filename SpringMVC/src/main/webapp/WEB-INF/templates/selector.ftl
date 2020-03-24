<!doctype html>
<#assign sf=JspTaglibs["http://www.springframework.org/tags/form"]>

<html>
<script language="JavaScript" type="text/javascript">
    // Actualize value of result hidden field
    function updateHiddenFromSelect(select) {
        let value = "";
        let option;
        for (option of select) {
            if(value.length > 0) value += ",";
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
        const  selected = getSelectOptions(input);

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
            if(option.selected) {
                result.push(option);
            }
        }

        return result;
    } // end getSelectValues
</script>
<head>
</head>
<body>
<h2>Select : ${title}</h2>
<@sf.form action="/rules/${id}/rule/selector" method="post">
    <table border="0">
        <tr>
            <td>
                <div>
                    <input id="attribute" name="attribute" type="hidden" value="${attribute}"/>
                    <input id="selected" name="selected" type="hidden" value="${listSelected?join(",")}"/>
                    <input type="submit">
                    <input name="home" value="Cancel" title="Cancel" type="button"
                           onClick="location.href='/rules/${id}/rule'">
                </div>
            </td>
        </tr>
        <tr>
            <td valign="top">
                <table border="0">
                    <tr>
                        <td>
                            <select id="listIn" name="listIn" multiple size="10" style="width:200px">>
                                <#list listAvailable as row>
                                    <option value="${row}">${row}</option>
                                </#list>
                            </select>
                        </td>
                        <td>
                            <table border="0">
                                <tr>
                                    <td>
                                        <button type="button" onclick="onAdd()">&gt;</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <button type="button" onclick="onRemove()">&lt;</button>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td>
                            <select id="listOut" name="listOut" multiple size="10" style="width:200px">
                                <#list listSelected as row>
                                    <option value="${row}">${row}</option>
                                </#list>
                            </select>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</@sf.form>
</body>
</html>