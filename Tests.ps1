Import-Module "Pester";
Import-Module "$PSScriptRoot/scripts/Ion-Tests.psm1" -Force;

Describe -tag "template-rendering" -Name "template-rendering tests" {
  It "Should render template with solution for each service type: <svc>" -ForEach @(
    @{ "SVC" = "job" },
    @{ "SVC" = "microservice" },
    @{ "SVC" = "microservice-api" },
    @{ "SVC" = "microservice-minimal-api" },
    @{ "SVC" = "microservice-graphql-api" },
    @{ "SVC" = "microservice-grpc-api" },
    @{ "SVC" = "microservice-grpc-minimal-api" }
  ) {
    Start-TemplateRenderingTest -Type $SVC -Solution $true -Root $PSScriptRoot;
  }

  It "Should render template without solution for each service type: <svc>" -ForEach @(
    @{ "SVC" = "job" },
    @{ "SVC" = "microservice" },
    @{ "SVC" = "microservice-api" },
    @{ "SVC" = "microservice-minimal-api" },
    @{ "SVC" = "microservice-graphql-api" },
    @{ "SVC" = "microservice-grpc-api" },
    @{ "SVC" = "microservice-grpc-minimal-api" }
  ) {
    Start-TemplateRenderingTest -Type $SVC -Solution $false -Root $PSScriptRoot;
  }
}

Describe -tag "template-build" -Name "template building tests" {
  It "Should build the template with solution for each service <svc>" -ForEach @(
    @{ "SVC" = "job" },
    @{ "SVC" = "microservice" },
    @{ "SVC" = "microservice-api" },
    @{ "SVC" = "microservice-minimal-api" },
    @{ "SVC" = "microservice-graphql-api" },
    @{ "SVC" = "microservice-grpc-api" },
    @{ "SVC" = "microservice-grpc-minimal-api" }
  ) {
    Start-TemplateBuildTest -Type $SVC -Root $PSScriptRoot;
  }
}