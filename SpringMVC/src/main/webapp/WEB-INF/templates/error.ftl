<#import "container.ftl" as c>
<@c.container>
    <div class="card w-50">
        <h5 class="card-header">Error</h5>
        <div class="card-body">
            <div class="alert alert-danger" role="alert">
                ${errorMessage}
            </div>
            <input class="btn btn-primary mt-2" name="home" value="OK" title="OK" type="button"
                   onClick="location.href='${returnPath}'">
        </div>
    </div>
</@c.container>