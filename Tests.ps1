Import-Module "Pester";
Import-Module "$PSScriptRoot/scripts/Ion-Tests.psm1" -Force;

[hashtable]$suffix = @{
  "job" = "Job"
  "microservice" = "Svc"
};

Describe -tag "E2ETest" -Name "ion-services" {
  It "Should render template with solution for each service type: <svc>" -ForEach @(
    @{ "SVC" = "job" }
    @{ "SVC" = "microservice" }
  ) {
    RunRenderTemplateTest -Type $SVC -Solution $true -Root $PSScriptRoot;
  }

  # It "Should build the template with solution for each service <svc>" -ForEach @(
  #   @{ "SVC" = "job" }
  #   @{ "SVC" = "microservice" }
  # ) {
    
  #   Remove-Item -Path "tests/$SVC" -Recurse -Force -ErrorAction Ignore;
  #   & dotnet new -i "./$SVC"

  #   New-Item -Name "tests/$SVC" -ItemType "directory";

  #   try {
  #     Push-Location "$PSScriptRoot/tests/$SVC";

  #     & dotnet new ion-$SVC --project "Project" --service "Service"
  #   } finally {
  #     Pop-Location;
  #   }

  #   try {
  #     Push-Location "$PSScriptRoot/tests/$SVC/project-service-$($suffix[$SVC].ToString().ToLowerInvariant())/src/Project.Service.$($suffix[$SVC])";

  #     & dotnet restore 

  #     $LASTEXITCODE | Should -Be 0 -Because "dotnet restore should pass for $SVC";

  #     & dotnet build --no-restore

  #     $LASTEXITCODE | Should -Be 0 -Because "dotnet build should pass for $SVC";
  #   } finally {
  #     Pop-Location;
  #   }
  # }
}