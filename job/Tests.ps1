Import-Module "Pester";

Describe -tag "E2ETest" -Name "ion-job" {
  It "Should generate a project with .sln" {
    # Arrange
    dotnet new -i ./

    # Act
    dotnet new ion-job --project Xray --service Tango --force

    # Assert
    # TODO: Test if ignored files/folders are absent
    # TODO: Test if solution builds
    # TODO: Test if solution tests
  }

  It "Should run tests for each <svc> service" -ForEach @(
    @{ "SVC" = "ion-job" }
  ) {
    $SVC;
  }

  It "Should throw test" {
    {
      # something in here
    } | Should -Throw "error message"
  }
}