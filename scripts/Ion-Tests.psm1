Import-Module "Pester";

[hashtable]$suffix = @{
  "job"                         = "job"
  "microservice"                = "svc"
  "microservice-api"            = "api"
  "microservice-minimal-api"    = "api"
  "microservice-graphql-api"    = "graphql-api"
  "microservice-grpc-api"         = "grpc-api"
  "microservice-grpc-minimal-api" = "grpc-api"
};

[hashtable]$csprojSuffix = @{
  "job"                   = "Job"
  "microservice"          = "Svc"
  "microservice-api"      = "Api"
  "microservice-minimal-api"    = "Api"
  "microservice-graphql-api"    = "GraphQL"
  "microservice-grpc-api"         = "Grpc"
  "microservice-grpc-minimal-api" = "Grpc"
};

function Start-TemplateRenderingTest {
  param(
    [string]$Type,
    [bool]$Solution = $true,
    [string]$Root
  )

  Remove-Item -Path "$Root/tests/$Type" -Recurse -Force -ErrorAction Ignore;
  dotnet new -i "$Root/$Type"

  Push-Location $Root;
  New-Item -Name "tests/$Type" -ItemType "directory" -Force;
  Pop-Location;

  Push-Location "$Root/tests/$Type";

  if ($true -eq $solution) {
    dotnet new ion-$Type --project "Project" --service "Service"

    Test-Path "$Root/tests/$Type/Project.Service.sln" | Should -Be $true -Because ".sln file should exist";
    Test-Path "$Root/tests/$Type/.editorconfig" | Should -Be $true -Because ".editoconfig file should exist";
    Test-Path "$Root/tests/$Type/LICENSE" | Should -Be $true -Because "license file should exist";
    Test-Path "$Root/tests/$Type/readme.md" | Should -Be $true -Because "readme.md should exist";
    Test-Path "$Root/tests/$Type/src" | Should -Be $true -Because "service folder should exist";
    Test-Path "$Root/tests/$Type/.nuke" | Should -Be $true -Because ".nuke folder should exist";
    Test-Path "$Root/tests/$Type/build" | Should -Be $true -Because "build folder should exist";
  }
  else {
    dotnet new ion-$Type --project "Project" --service "Service" --solution false

    Test-Path "$Root/tests/$Type/Project.Service.sln" | Should -Be $false -Because ".sln file should not exist";
    Test-Path "$Root/tests/$Type/.editorconfig" | Should -Be $false -Because ".editoconfig file should not exist";
    Test-Path "$Root/tests/$Type/LICENSE" | Should -Be $false -Because "license file should not exist";
    Test-Path "$Root/tests/$Type/readme.md" | Should -Be $false -Because "readme.md should not exist";
    Test-Path "$Root/tests/$Type/src" | Should -Be $true -Because "service folder should exist";
  }

  Pop-Location;

  Test-Path "tests/$Type/.idea" | Should -Be $false -Because "JetBrains IDE folders should not exist";
}

function Start-TemplateBuildTest {
  param(
    [string]$Type,
    [string]$Root
  )

  Remove-Item -Path "$Root/tests/$Type" -Recurse -Force -ErrorAction Ignore;

  & dotnet new -i "$Root/$Type"


  Push-Location $Root;
  New-Item -Name "tests/$Type" -ItemType "directory" -Force;
  Pop-Location;

  try {
    Push-Location "$Root/tests/$Type";

    & dotnet new ion-$Type --project "Project" --service "Service"
  }
  finally {
    Pop-Location;
  }

  try {
    Push-Location "$Root/tests/$Type/src/Project.Service.$($csprojSuffix[$Type])";

    & dotnet restore

    $LASTEXITCODE | Should -Be 0 -Because "dotnet restore should pass for $Type";

    & dotnet build --no-restore

    $LASTEXITCODE | Should -Be 0 -Because "dotnet build should pass for $Type";
  }
  finally {
    Pop-Location;
  }
}

Export-ModuleMember -Function Start-TemplateRenderingTest;
Export-ModuleMember -Function Start-TemplateBuildTest;
