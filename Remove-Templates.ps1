#!/usr/local/bin/pwsh
$ErrorActionPreference = "Stop"

[string[]]$templates = @(
  "job"
  "microservice"
  "microservice-api"
  "microservice-minimal-api"
  "microservice-graphql-api"
  "microservice-grpc-api"
  "microservice-grpc-minimal-api"
  "microservice-mcp"
);

$templates | % {
  & dotnet new uninstall "$PSScriptRoot/$_"
}
