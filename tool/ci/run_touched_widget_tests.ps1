param(
  [string]$BaseRef = "HEAD~1",
  [string]$HeadRef = "HEAD"
)

$ErrorActionPreference = "Stop"

function Run-Tests([string[]]$paths) {
  if ($paths.Count -eq 0) {
    Write-Host "No touched widget tests to run."
    exit 0
  }

  $quoted = $paths | ForEach-Object { "`"$_`"" }
  $args = ($quoted -join " ")
  $command = "flutter test --reporter expanded $args"
  Write-Host "Running: $command"
  Invoke-Expression $command
}

$changed = git diff --name-only $BaseRef $HeadRef
if (-not $changed) {
  Write-Host "No changed files detected."
  exit 0
}

$changed = $changed | Where-Object { $_ -ne "" }
$targetTests = New-Object System.Collections.Generic.HashSet[string]

foreach ($file in $changed) {
  if ($file -like "test/widgets/*") {
    $targetTests.Add($file) | Out-Null
  }

  if ($file -like "lib/presentation/authentication/*") {
    $targetTests.Add("test/widgets/auth/sign_in_page_widget_test.dart") | Out-Null
    $targetTests.Add("test/widgets/auth/register_page_widget_test.dart") | Out-Null
    $targetTests.Add("test/widgets/auth/request_email_view_widget_test.dart") | Out-Null
  }

  if ($file -like "lib/presentation/settings/*") {
    $targetTests.Add("test/widgets/settings/settings_view_widget_test.dart") | Out-Null
    $targetTests.Add("test/widgets/settings/theme_view_widget_test.dart") | Out-Null
  }
}

Run-Tests -paths (@($targetTests) | Sort-Object)
