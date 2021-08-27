Import-Module "Pester";

Describe -tag "E2ETest" -Name "ion-job" {
  It "Should render template with solution for each <svc> service " -ForEach @(
    @{ "SVC" = "job" }
    @{ "SVC" = "microservice" }
  ) {
    
    Remove-Item -Path "tests" -Recurse -Force -ErrorAction Ignore;
    dotnet new -i "./$SVC"

    New-Item -Name "tests" -ItemType "directory";

    Push-Location "$PSScriptRoot/tests";

    dotnet new ion-$SVC --project "Project" --service "Service"

    Pop-Location;

    Test-Path "tests/Project.sln" | Should -Be $true;
    Test-Path "tests/.editorconfig" | Should -Be $true;
    Test-Path "tests/LICENSE" | Should -Be $true;
    Test-Path "tests/readme.md" | Should -Be $true;
    Test-Path "tests/project-service-job" | Should -Be $true;

    Test-Path "tests/.idea" | Should -Be $false;
  }

  It "Should build the template with solution for each <svc> service " -ForEach @(
    @{ "SVC" = "job" }
    @{ "SVC" = "microservice" }
  ) {
    
    Remove-Item -Path "tests" -Recurse -Force -ErrorAction Ignore;
    & dotnet new -i "./$SVC"

    New-Item -Name "tests" -ItemType "directory";

    try {
      Push-Location "$PSScriptRoot/tests";

      & dotnet new ion-$SVC --project "Project" --service "Service"
    } finally {
      Pop-Location;
    }

    try {
      [hashtable]$suffix = @{
        "job" = "Job"
        "microservice" = "Svc"
      };
      Push-Location "$PSScriptRoot/tests/project-service-$SVC/src/Project.Service.$($suffix[$SVC])";

      & dotnet restore 

      $LASTEXITCODE | Should -Be 0 -Because "dotnet restore should pass for $SVC";

      & dotnet build --no-restore

      $LASTEXITCODE | Should -Be 0 -Because "dotnet build should pass for $SVC";
    } finally {
      Pop-Location;
    }
  }
}