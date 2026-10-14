param(
  [Parameter(Mandatory=$true)][string]$Repo,
  [string]$Pasta = "."
)
$ErrorActionPreference = "Stop"

$rsul = Get-ChildItem -Path $Pasta -File | Where-Object { $_.Name -match '^RSUL-(\d{2}-\d{2})\.json$' } | Sort-Object Name -Descending | Select-Object -First 1
if (-not $rsul) { throw "Arquivo RSUL-AA-MM.json não encontrado em $Pasta" }
$competencia = [regex]::Match($rsul.Name, '^RSUL-(\d{2}-\d{2})\.json$').Groups[1].Value
$leste = Join-Path $Pasta "RLESTE-$competencia.json"
if (-not (Test-Path $leste)) { throw "Arquivo RLESTE-$competencia.json não encontrado em $Pasta" }

$ano = "20" + $competencia.Substring(0,2)
$mes = $competencia.Substring(3,2)
$tag = "bases-$ano-$mes"

& gh release view $tag --repo $Repo *> $null
if ($LASTEXITCODE -eq 0) {
  gh release upload $tag $rsul.FullName $leste --repo $Repo --clobber
  gh release edit $tag --repo $Repo --latest --draft=false --prerelease=false
} else {
  gh release create $tag $rsul.FullName $leste --repo $Repo --title "Bases $competencia" --notes "Bases compactadas RSul e Região Leste — competência $competencia." --latest
}
Write-Host "Release $tag publicada com $($rsul.Name) e RLESTE-$competencia.json"
