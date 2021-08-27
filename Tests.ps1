Import-Module "Pester";
Import-Module "$PSScriptRoot/scripts/Ion-Tests.psm1" -Force;

Describe -tag "job" -Name "ion-job tests" {
  It "Should render template with solution for each service type: <svc>" -ForEach @(
    @{ "SVC" = "job" }
  ) {
    Start-TemplateRenderingTest -Type $SVC -Solution $true -Root $PSScriptRoot;
  }

  It "Should build the template with solution for each service <svc>" -ForEach @(
    @{ "SVC" = "job" }
  ) {
    Start-TemplateBuildTest -Type $SVC -Root $PSScriptRoot;
  }
}

Describe -tag "microservice" -Name "ion-microservice tests" {
  It "Should render template with solution for each service type: <svc>" -ForEach @(
    @{ "SVC" = "microservice" }
  ) {
    Start-TemplateRenderingTest -Type $SVC -Solution $true -Root $PSScriptRoot;
  }

  It "Should build the template with solution for each service <svc>" -ForEach @(
    @{ "SVC" = "microservice" }
  ) {
    Start-TemplateBuildTest -Type $SVC -Root $PSScriptRoot;
  }
}