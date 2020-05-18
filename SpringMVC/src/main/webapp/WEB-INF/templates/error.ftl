<#import "container.ftl" as c>
<@c.container>
    <div class="card border-danger w-50">
        <h5 class="card-header">Error</h5>
        <div class="card-body text-danger">
                ${errorMessage}
            <div class="text-center mt-3">
            <input class="btn btn-primary" name="Close" value="Close" title="Close" type="button"
                   onClick="location.href='${returnPath}'">
            </div>
        </div>
    </div>
</@c.container>