<!doctype html>
<#assign sf=JspTaglibs["http://www.springframework.org/tags/form"]>

<html>
<head>
</head>
<body>
<h2>New accessor</h2>
<table border="0">
    <@sf.form action="/rules/${accessor.getId()}/accessor" method="post" modelAttribute="accessor">
        <tr>
            <td>
                <div>
                    <input type="submit">
                    <input name="home" value="Cancel" title="Cancel" type="button"
                           onClick="location.href='/rules/${accessor.getParentId()}/rule'">
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <@sf.label path="name">Name</@sf.label>
            </td>
            <td>
                <@sf.hidden path="id"/>
                <@sf.hidden path="parentId"/>
                <@sf.input path="name"/>
            </td>
            <td>
                <div style="color:red;font-style:italic;">
                    <@sf.errors path="name"/>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <@sf.label path="alias">Is alias?</@sf.label>
            </td>
            <td>
                <@sf.checkbox path="alias"/>
            </td>
            <td>
                <div style="color:red;font-style:italic;">
                    <@sf.errors path="alias"/>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <@sf.label path="svc">Is service?</@sf.label>
            </td>
            <td>
                <@sf.checkbox path="svc"/>
            </td>
            <td>
                <div style="color:red;font-style:italic;">
                    <@sf.errors path="svc"/>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <@sf.label path="permit">permit</@sf.label>
            </td>
            <td>
                <@sf.select path="permit">
                    <@sf.option value="0" label=""/>
                    <@sf.option value="1" label="NONE"/>
                    <@sf.option value="2" label="BROWSE"/>
                    <@sf.option value="3" label="READ"/>
                    <@sf.option value="4" label="RELATE"/>
                    <@sf.option value="5" label="VERSION"/>
                    <@sf.option value="6" label="WRITE"/>
                    <@sf.option value="7" label="DELETE"/>
                </@sf.select>
            </td>
            <td>
                <div style="color:red;font-style:italic;">
                    <@sf.errors path="permit"/>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <@sf.label path="xPermits">XPermits</@sf.label>
            </td>
            <td>
                <@sf.input path="xPermits"/>
            </td>
            <td>
                <div style="color:red;font-style:italic;">
                    <@sf.errors path="xPermits"/>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <@sf.label path="orgLevels">Org.Levels</@sf.label>
            </td>
            <td>
                <@sf.input path="orgLevels"/>
            </td>
            <td>
                <div style="color:red;font-style:italic;">
                    <@sf.errors path="orgLevels"/>
                </div>
            </td>
        </tr>
    </@sf.form>
</table>
</body>
</html>
