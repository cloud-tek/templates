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
);

$templates | % {
  & dotnet new -u "$PSScriptRoot/$_"
  & dotnet new -i "$PSScriptRoot/$_"
}
