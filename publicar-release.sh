#!/usr/bin/env bash
set -euo pipefail
repo="${1:?Uso: ./publicar-release.sh OWNER/REPO [PASTA]}"
pasta="${2:-.}"

rsul="$(find "$pasta" -maxdepth 1 -type f -regextype posix-extended -regex '.*/RSUL-[0-9]{2}-[0-9]{2}\.json' | sort -r | head -n1)"
[[ -n "$rsul" ]] || { echo "RSUL-AA-MM.json não encontrado em $pasta" >&2; exit 1; }
base="$(basename "$rsul")"
competencia="${base#RSUL-}"; competencia="${competencia%.json}"
leste="$pasta/RLESTE-$competencia.json"
[[ -f "$leste" ]] || { echo "RLESTE-$competencia.json não encontrado em $pasta" >&2; exit 1; }
tag="bases-20${competencia:0:2}-${competencia:3:2}"

if gh release view "$tag" --repo "$repo" >/dev/null 2>&1; then
  gh release upload "$tag" "$rsul" "$leste" --repo "$repo" --clobber
  gh release edit "$tag" --repo "$repo" --latest --draft=false --prerelease=false
else
  gh release create "$tag" "$rsul" "$leste" --repo "$repo" --title "Bases $competencia" --notes "Bases compactadas RSul e Região Leste — competência $competencia." --latest
fi
echo "Release $tag publicada com $base e $(basename "$leste")"
