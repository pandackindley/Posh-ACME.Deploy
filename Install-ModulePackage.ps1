[CmdletBinding()]
param()
try {
  $MName = Split-Path (Split-Path $PSScriptRoot -Parent) -Leaf
  Write-Verbose "module: $MName"
  $metadata = Get-Content -Raw -Path "$PSScriptRoot\metadata.json" -ErrorAction SilentlyContinue | ConvertFrom-Json
  $MVersion = $metadata.version
  Write-Verbose "version: $MVersion"
  $TargetPath = Join-Path -Path $env:ProgramFiles -ChildPath "WindowsPowerShell\Modules\$MName\$MVersion"
  # check if module + version target folder exists
  if (-not (Test-Path $TargetPath)) {
    $SourcePath = Join-Path -Path $PSScriptRoot -ChildPath $($metadata.ModuleDirectory)
    Write-Verbose "installing module: $MName $MVersion"
    mkdir $TargetPath -Force -ErrorAction Stop | Out-Null
    xcopy $SourcePath\*.* $TargetPath /s
    $result = 0
  }
  else {
    Write-Verbose "module already installed"
    $result = 1
  }
}
catch {
  Write-Verbose $_.Exception.Message
  $result = -1
}
finally {
  Write-Output $result
}