param (      
    [Parameter(Mandatory = $true)] [String]$EnvironmentName,
    [Parameter(Mandatory = $true)] [String]$Mode,
    [Parameter(Mandatory = $true)] [String]$ClientSecretKey,
    [Parameter(Mandatory = $false)] [String]$BackendAccessKey
)

function EvaluateExitCode () {   
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Exit code: $LASTEXITCODE"
        exit $LASTEXITCODE      
    }
}

function ReplaceKeys ([bool] $reverse = $false) {
    if ($reverse) {
        (Get-Content 'main.tf' ) | foreach {$_.replace($BackendAccessKey, '%backendAccessKey%')} | Set-Content 'main.tf' -Force
        (Get-Content 'main.tf' ) | foreach {$_.replace($ClientSecretKey, '%clientSecretKey%')} | Set-Content 'main.tf' -Force
    } else {
        (Get-Content 'main.tf' ) | foreach {$_.replace('%backendAccessKey%', $BackendAccessKey)} | Set-Content 'main.tf' -Force
        (Get-Content 'main.tf' ) | foreach {$_.replace('%clientSecretKey%', $ClientSecretKey)} | Set-Content 'main.tf' -Force  
    }   
}

function Clean () {
    Remove-Item .terraform -force -recurse -ErrorAction SilentlyContinue
    Remove-Item tfplan -ErrorAction SilentlyContinue
}

try { 
    cd ".\environments\$EnvironmentName\"
    
    if ($Mode -like ("Plan")) {
        if ([string]::IsNullOrEmpty($BackendAccessKey)) {
            Write-Error("Backend access key is required to retrieve the terraform state when creating the plan.")
            exit 1
        }      
       
        ReplaceKeys

        Clean

        terraform init -input=false
        EvaluateExitCode
   
        terraform plan -out=tfplan
        EvaluateExitCode
    }
    elseif ($Mode -like ("Apply")) {
        terraform apply -auto-approve tfplan
        EvaluateExitCode
    }
    else {
        Write-Host "Please, provide a valid execution Mode using: -Mode 'Plan' or -Mode 'Apply')"
        exit 1
    }
}
finally {
    if ($Mode -like ("Plan")){
        ReplaceKeys $true
    }
    cd ../../
    EvaluateExitCode
}