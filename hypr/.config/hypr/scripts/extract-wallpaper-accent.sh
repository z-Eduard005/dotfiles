#!/bin/bash
set -euo pipefail

IMG="$(awww query | grep -oP 'image: \K.*' | head -1)"
ACCENTS=(
  blue:#3584e4
  teal:#2190a4
  green:#3a944a
  yellow:#c88800
  orange:#ed5b00
  red:#e62d42
  pink:#d56199
  purple:#9141ac
  slate:#6f8396
)

[ -n "$IMG" ] || { echo "no wallpaper found" >&2; echo slate; exit 0; }

# --- candidates: whatever matugen extracts (2 or 4, both fine) ---
CANDS=()
while IFS= read -r c; do
  [ -n "$c" ] && CANDS+=("$c")
done < <(matugen image "$IMG" --dry-run --show-source-colors)

WINNER=""
if [ "${#CANDS[@]}" -gt 0 ]; then
  # --- usage %: force every pixel onto its nearest candidate, count votes ---
  # (left join so 0-vote candidates still appear as 0%)
  declare -A COV=()
  PAL=()
  for c in "${CANDS[@]}"; do PAL+=(-size 1x1 "xc:$c"); done
  while read -r cnt hex tot; do
    [ -n "$hex" ] && COV["$hex"]=$(( cnt * 100 / tot ))
  done < <(
    magick "${PAL[@]}" +append -write mpr:pal +delete \
      -define jpeg:size=400x400 "$IMG" -resize 200x200 +dither -remap mpr:pal -format '%c' histogram:info: \
      | awk -v clist="${CANDS[*]}" '
          { k = toupper(substr($3, 1, 7)); cnt[k] += $1; tot += $1 }
          END {
            n = split(clist, a, " ");
            for (i = 1; i <= n; i++)
              printf "%d %s %d\n", cnt[toupper(a[i])] + 0, toupper(a[i]), tot;
          }'
  )

  # --- perceptual match: Oklab coords once per color, score in awk ---
  # A raw `compare` distance lumps lightness into hue, which made dark
  # wallpapers pick mid-light accents (purple beat slate on a mountain
  # shot).  Hue, chroma and lightness are therefore scored separately:
  #   score = hueSim x chromaSim x lightSim x usage%^POW
  #     hueSim   tolerance 60deg  (same color family)
  #     chromaSim tolerance 0.20  (Oklab chroma units)
  #     lightSim  tolerance 0.60  (Oklab L units)
  #     POW      usage damping: 1 = raw multiplication, 0.5 = balanced.
  #              override per run: ACCENT_USAGE_POW=1 ./extract-accent.sh
  POW="${ACCENT_USAGE_POW:-0.5}"
  oklab() { magick "xc:$1" -colorspace Oklab -format '%[fx:r] %[fx:g] %[fx:b]' info: 2>/dev/null; }

  SCORES=$(
    {
      for a in "${ACCENTS[@]}"; do ( echo "A ${a%%:*} $(oklab "${a##*:}")" ) & done
      for c in "${CANDS[@]}"; do ( echo "C ${c^^} $(oklab "$c") ${COV[${c^^}]:-0}" ) & done
      wait || true
    } | awk -v pow="$POW" '
      $1 == "A" { nm = $2; LA[nm] = $3; AA[nm] = $4 - 0.5; BB[nm] = $5 - 0.5; ord[++n] = nm }
      $1 == "C" { CL[$2] = $3; CA[$2] = $4 - 0.5; CB[$2] = $5 - 0.5; CV[$2] = $6; cs[++m] = $2 }
      END {
        if (n * m == 0) exit
        PI = 3.14159265
        for (i = 1; i <= n; i++) {
          nm = ord[i]
          for (j = 1; j <= m; j++) {
            c = cs[j]
            dh = atan2(BB[nm], AA[nm]) - atan2(CB[c], CA[c])
            if (dh >  PI) dh -= 2 * PI
            if (dh < -PI) dh += 2 * PI
            dh *= 180 / PI; if (dh < 0) dh = -dh
            hue = 1 - dh / 60;   if (hue < 0) hue = 0; if (hue > 1) hue = 1
            ca = sqrt(AA[nm] * AA[nm] + BB[nm] * BB[nm])
            cc = sqrt(CA[c] * CA[c] + CB[c] * CB[c])
            dc = ca - cc;        if (dc < 0) dc = -dc
            chr = 1 - dc / 0.2;  if (chr < 0) chr = 0; if (chr > 1) chr = 1
            dl = LA[nm] - CL[c]; if (dl < 0) dl = -dl
            lit = 1 - dl / 0.6;  if (lit < 0) lit = 0; if (lit > 1) lit = 1
            printf "%.4f %s\n", hue * chr * lit * (CV[c] ^ pow), nm
          }
        }
      }' | sort -rn
  )

  if [ -t 2 ] && [ -n "$SCORES" ]; then
    echo "top scores (Oklab hue x chroma x light x usage%^$POW):" >&2
    printf '%s\n' "$SCORES" | head -3 | sed 's/^/  /' >&2
  fi
  # best score must be > 0 (all-zero means measuring failed, not a real result)
  WINNER=$(printf '%s\n' "$SCORES" | head -1 | awk '$1 + 0 > 0 { print $2 }')
fi

echo "${WINNER:-slate}"
