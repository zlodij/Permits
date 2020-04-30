<#import "container.ftl" as c>
<@c.container "Error">
    <table>
        <tr>
            <td>
                <div>
                    <h4 style="color: red;font-style: italic;">${errorMessage}</h4>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <div>
                    <input name="home" value="OK" title="OK" type="button"
                           onClick="location.href='/rules'">
                </div>
            </td>
        </tr>
    </table>
</@c.container>