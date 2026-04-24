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
  dotnet new -i "$Root/$Type" --force

  Push-Location $Root;
  New-Item -Name "tests/$Type" -ItemType "directory" -Force;
  Pop-Location;

  try {
    Push-Location "$Root/tests/$Type";

    if ($true -eq $Solution) {
      dotnet new "hive-$Type" -pr "Project" -svc "Service" | Write-Host

      Test-Path "$Root/tests/$Type/Project.Service.sln" | Should -Be $true -Because ".sln file should exist";
      Test-Path "$Root/tests/$Type/.editorconfig" | Should -Be $true -Because ".editoconfig file should exist";
      Test-Path "$Root/tests/$Type/LICENSE" | Should -Be $true -Because "license file should exist";
      Test-Path "$Root/tests/$Type/readme.md" | Should -Be $true -Because "readme.md should exist";
      Test-Path "$Root/tests/$Type/src" | Should -Be $true -Because "service folder should exist";
    }
    else {
      dotnet new hive-$Type -pr "Project" -svc "Service" --solution false

      Test-Path "$Root/tests/$Type/Project.Service.sln" | Should -Be $false -Because ".sln file should not exist";
      Test-Path "$Root/tests/$Type/.editorconfig" | Should -Be $false -Because ".editoconfig file should not exist";
      Test-Path "$Root/tests/$Type/LICENSE" | Should -Be $false -Because "license file should not exist";
      Test-Path "$Root/tests/$Type/readme.md" | Should -Be $false -Because "readme.md should not exist";
      Test-Path "$Root/tests/$Type/src" | Should -Be $true -Because "service folder should exist";
    }
  } finally {

    Pop-Location;
  }
  Test-Path "tests/$Type/.idea" | Should -Be $false -Because "JetBrains IDE folders should not exist";
}

function Start-TemplateBuildTest {
  param(
    [string]$Type,
    [string]$Root
  )

  Remove-Item -Path "$Root/tests/$Type" -Recurse -Force -ErrorAction Ignore;

  & dotnet new -i "$Root/$Type" --force

  Push-Location $Root;
  New-Item -Name "tests/$Type" -ItemType "directory" -Force;
  Pop-Location;

  try {
    Push-Location "$Root/tests/$Type";

    & dotnet new hive-$Type -pr "Project" -svc "Service"
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

function Start-TemplateRunTest {
  param(
    [string]$Type,
    [string]$Root,
    [int]$StartupTimeoutSec = 30,
    [int]$ShutdownTimeoutSec = 45
  )

  $traceLog = "$Root/tests/run-trace.log";
  New-Item -ItemType Directory -Path "$Root/tests" -Force | Out-Null;
  function _Trace([string]$Msg) {
    $line = "$(Get-Date -Format 'HH:mm:ss.fff') [$Type] $Msg";
    Add-Content -Path $traceLog -Value $line;
    [Console]::Error.WriteLine($line);
  }

  _Trace "START";
  Remove-Item -Path "$Root/tests/$Type" -Recurse -Force -ErrorAction Ignore;
  _Trace "cleaned test dir";

  _Trace "dotnet new -i ...";
  & dotnet new -i "$Root/$Type" --force
  _Trace "dotnet new -i done (exit=$LASTEXITCODE)";

  Push-Location $Root;
  New-Item -Name "tests/$Type" -ItemType "directory" -Force | Out-Null;
  Pop-Location;

  try {
    Push-Location "$Root/tests/$Type";
    _Trace "dotnet new hive-$Type ...";
    & dotnet new hive-$Type -pr "Project" -svc "Service"
    _Trace "render done (exit=$LASTEXITCODE)";
  }
  finally {
    Pop-Location;
  }

  $suffix = $csprojSuffix[$Type];
  $projectDir = "$Root/tests/$Type/src/Project.Service.$suffix";
  $stdoutLog = "$Root/tests/$Type/stdout.log";
  $stderrLog = "$Root/tests/$Type/stderr.log";

  try {
    Push-Location $projectDir;
    _Trace "dotnet build ...";
    & dotnet build --nologo
    _Trace "build done (exit=$LASTEXITCODE)";
    $LASTEXITCODE | Should -Be 0 -Because "dotnet build should succeed before run for $Type";
  }
  finally {
    Pop-Location;
  }

  # Run the built DLL directly — `dotnet run` spawns the app as a child process,
  # so SIGTERM to the wrapper wouldn't reach the app. Invoking the DLL makes
  # the dotnet process BE the app, so SIGTERM triggers the generic host's
  # graceful shutdown and exit code 0.
  $dllPath = "$projectDir/bin/Debug/net10.0/Project.Service.$suffix.dll";
  _Trace "dll = $dllPath";
  Test-Path $dllPath | Should -Be $true -Because "built DLL should exist at $dllPath";

  # Set ASPNETCORE_URLS on the parent env so the child inherits it. Ephemeral
  # port (:0) avoids :5000 collisions with anything else running on the dev
  # machine. No shell wrapper: Start-Process -FilePath /bin/sh -ArgumentList
  # @('-c', '...') has historically mis-split multi-token arg lists, which
  # caused `sh -c export` to run and dump the parent's env (including secrets)
  # to the captured stdout.
  _Trace "starting process";
  $prevUrls = [Environment]::GetEnvironmentVariable('ASPNETCORE_URLS');
  [Environment]::SetEnvironmentVariable('ASPNETCORE_URLS', 'http://127.0.0.1:0');
  try {
    $proc = Start-Process -FilePath 'dotnet' `
      -ArgumentList @($dllPath) `
      -WorkingDirectory $projectDir `
      -RedirectStandardOutput $stdoutLog `
      -RedirectStandardError $stderrLog `
      -PassThru -NoNewWindow
  }
  finally {
    [Environment]::SetEnvironmentVariable('ASPNETCORE_URLS', $prevUrls);
  }
  # Force handle caching — without this, Start-Process -PassThru's Process
  # object doesn't update HasExited after the child exits.
  $null = $proc.Handle;
  _Trace "started pid=$($proc.Id)";

  try {
    # Discover the OS-assigned port from Kestrel's "Now listening on" log,
    # then poll /status/liveness until it returns 2xx. Any non-success response
    # (e.g. 404) keeps retrying rather than being treated as "up" — a template
    # without a working liveness endpoint should fail loud, not silent.
    $deadline = (Get-Date).AddSeconds($StartupTimeoutSec);
    $port = $null;
    $ready = $false;
    $listenRegex = 'Now listening on:\s+http://127\.0\.0\.1:(\d+)';
    _Trace "waiting up to $StartupTimeoutSec s for bound port + liveness";

    while ((Get-Date) -lt $deadline -and -not $ready) {
      if ($proc.HasExited) {
        _Trace "process exited during startup, code=$($proc.ExitCode)";
        $proc.ExitCode | Should -Be 0 -Because "template '$Type' exited before reaching liveness; see $stdoutLog and $stderrLog";
        return;
      }
      if (-not $port) {
        $out = Get-Content -Path $stdoutLog -Raw -ErrorAction SilentlyContinue;
        if ($out -and $out -match $listenRegex) {
          $port = $Matches[1];
          _Trace "Kestrel bound to port $port";
        }
      }
      if ($port) {
        try {
          $resp = Invoke-WebRequest -Uri "http://127.0.0.1:$port/status/liveness" `
            -TimeoutSec 2 -UseBasicParsing -ErrorAction Stop;
          _Trace "liveness probe got HTTP $($resp.StatusCode)";
          $ready = $true;
          break;
        } catch {
          # connection refused or non-2xx — not ready, retry
        }
      }
      Start-Sleep -Milliseconds 250;
    }

    if (-not $ready) {
      if (-not $port) {
        throw "Template '$Type' never logged a bound port within $StartupTimeoutSec s; see $stdoutLog";
      } else {
        throw "Template '$Type' bound port $port but /status/liveness never returned 2xx within $StartupTimeoutSec s; see $stdoutLog";
      }
    }

    _Trace "sending SIGTERM to pid=$($proc.Id)";
    & /bin/kill -TERM $proc.Id
    _Trace "SIGTERM sent";

    if (-not $proc.WaitForExit($ShutdownTimeoutSec * 1000)) {
      _Trace "did not exit within ${ShutdownTimeoutSec}s, killing";
      $proc.Kill();
      $proc.WaitForExit();
      throw "Template '$Type' did not exit within $ShutdownTimeoutSec seconds of SIGTERM";
    }
    _Trace "process exited after SIGTERM, code=$($proc.ExitCode)";

    $proc.ExitCode | Should -Be 0 -Because "template '$Type' should exit 0 after SIGTERM; see $stdoutLog and $stderrLog";
  }
  finally {
    if (-not $proc.HasExited) {
      try { $proc.Kill() } catch { }
    }
    _Trace "END";
  }
}

Export-ModuleMember -Function Start-TemplateRenderingTest;
Export-ModuleMember -Function Start-TemplateBuildTest;
Export-ModuleMember -Function Start-TemplateRunTest;
