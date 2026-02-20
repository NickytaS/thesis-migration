# Run mongify (install gem in a temporary ruby container and process translation)
# Usage: .\scripts\run-mongify.ps1

$repo = (Resolve-Path ..\).Path
$mongifyDir = Join-Path $repo 'mongify'

if (-not (Test-Path $mongifyDir)) { Write-Error "mongify folder not found: $mongifyDir" ; exit 1 }

Write-Host 'Installing mongify gem and running migration (blog DB)'

docker run --rm -v "${pwd}\..\mongify:/work" -w /work ruby:3.1 bash -lc "gem install mongify -v 1.4.1 --no-document && mongify process translation.rb --config database.yml"

if ($LASTEXITCODE -ne 0) { Write-Error 'mongify run failed' ; exit $LASTEXITCODE }
Write-Host 'mongify finished'
