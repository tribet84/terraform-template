param (
    [Parameter(Mandatory = $true)] [String]$Environment,
    [Parameter(Mandatory = $true)] [String]$Location,
    [Parameter(Mandatory = $true)] [String]$ResourceGroupName,
    [Parameter(Mandatory = $true)] [String]$ClientId,
    [Parameter(Mandatory = $true)] [String]$Secret,
    [Parameter(Mandatory = $true)] [String]$TenantId,
    [Parameter(Mandatory = $true)] [String]$SubscriptionId
)

try {
    
    Remove-Item .terraform -force -recurse -ErrorAction SilentlyContinue
    Remove-Item tfplan -ErrorAction SilentlyContinue
    Remove-Item *.tfstate -ErrorAction SilentlyContinue

    terraform init -input=false

    terraform plan `
        -var "environment=$Environment" `
        -var "location=$Location" `
        -var "resource_group_name=$ResourceGroupName" `
        -var "client_id=$ClientId" `
        -var "client_secret=$Secret" `
        -var "tenant_id=$TenantId" `
        -var "subscription_id=$SubscriptionId" `
        -out=tfplan
    
    $continue = read-host "Enter 'y' to apply terraform plan"
    if ($continue -eq "y") {
        terraform apply -auto-approve tfplan
    } else {
        "Aborted"
    }
}
catch {
    exit 1
}