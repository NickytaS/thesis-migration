# Run pgLoader using the provided pgloader_blog.conf
# Usage: .\scripts\run-pgloader.ps1

$repo = (Resolve-Path ..\).Path
$conf = Join-Path $repo 'pgloader_blog.conf'

if (-not (Test-Path $conf)) {
  Write-Error "pgloader config not found at $conf"
  exit 1
}

Write-Host "Running pgloader with config: $conf"

docker run --rm -v "${pwd}\..\pgloader_blog.conf:/pgloader.conf:ro" dimitri/pgloader:latest pgloader /pgloader.conf

if ($LASTEXITCODE -ne 0) { Write-Error 'pgloader run failed' ; exit $LASTEXITCODE }
Write-Host 'pgloader finished'
