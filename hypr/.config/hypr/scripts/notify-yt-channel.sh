#!/bin/bash
STATE="${XDG_STATE_HOME:-$HOME/.local/state}/notify-yt-channel"
CHANNELS="$STATE/channels"
SEEN="$STATE/seen"
PIDFILE="$STATE/pid"
INTERVAL=1440  # 24 minutes
FEED="https://www.youtube.com/feeds/videos.xml?channel_id="

help() {
  cat <<EOF
notify-yt-channel - get a desktop notification when a YouTube channel posts a new video.

Usage:
  notify-yt-channel start             Start watching in the background (checks every $((INTERVAL / 60)) min)
  notify-yt-channel stop              Stop watching
  notify-yt-channel add <channel>     Add a channel (youtube link, @handle or name)
  notify-yt-channel remove <ID>       Stop watching a channel
  notify-yt-channel list              Show watched channels
  notify-yt-channel --help            Show this help
EOF
}

running() { [[ -f $PIDFILE ]] && kill -0 "$(<"$PIDFILE")" 2>/dev/null; }

resolve() {
  local in=$1 handle
  if [[ $in =~ UC[A-Za-z0-9_-]{22} ]]; then
    echo "${BASH_REMATCH[0]}"
    return
  fi
  handle=${in#*youtube.com/}
  handle=${handle#@}
  handle=${handle%%[/?#]*}
  curl -fsSL "https://www.youtube.com/@$handle" | grep -oP 'youtube.com/channel/\KUC[\w-]{22}' | head -1
}

add() {
  local id xml name
  id=$(resolve "$1")
  [[ $id =~ ^UC[A-Za-z0-9_-]{22}$ ]] || { echo "Could not find channel: '$1'" >&2; exit 1; }
  grep -q "^$id" "$CHANNELS" 2>/dev/null && { echo "Already added: $id" >&2; exit 1; }
  xml=$(curl -fsS "$FEED$id") || { echo "Channel not found: $id" >&2; exit 1; }
  name=$(grep -m1 -oP '<name>\K[^<]+' <<<"$xml")
  echo "$id  # $name" >> "$CHANNELS"
  echo "Added: $name ($id)"
}

remove() {
  local id=$1
  grep -q "^$id" "$CHANNELS" 2>/dev/null || { echo "Not in list: $id" >&2; exit 1; }
  sed -i "/^$id/d" "$CHANNELS"
  rm -f "$SEEN/$id"
  echo "Removed: $id"
}

list() {
  [[ -s $CHANNELS ]] || { echo "No channels yet."; return; }
  cat "$CHANNELS"
}

watch() {
  while true; do
    mapfile -t channels < <(sed 's/#.*//; s/[[:space:]]//g; /^$/d' "$CHANNELS")
    for ch in "${channels[@]}"; do
      xml=$(curl -fsS "$FEED$ch") || continue
      author=$(grep -m1 -oP '<name>\K[^<]+' <<<"$xml")
      touch "$SEEN/$ch"

      paste -d'\t' \
        <(grep -oP '<yt:videoId>\K[^<]+' <<<"$xml") \
        <(grep -oP '<title>\K[^<]+' <<<"$xml" | tail -n +2) | tac |
      while IFS=$'\t' read -r id title; do
        grep -qx "$id" "$SEEN/$ch" && continue
        echo "$id" >> "$SEEN/$ch"
        title=$(sed 's/&amp;/\&/g; s/&quot;/"/g; s/&#39;/'"'"'/g; s/&lt;/</g; s/&gt;/>/g' <<<"$title")
        notify-send -a "Youtube Channels Notify" "$author" "$title"
      done
    done
    sleep "$INTERVAL"
  done
}

start() {
  running && { echo "Already running" >&2; exit 1; }
  [[ -s $CHANNELS ]] || { echo "No channels yet. Add one with: notify-yt-channel add <channel>" >&2; exit 1; }
  watch >/dev/null 2>&1 &
  echo $! > "$PIDFILE"
  echo "Started"
}

stop() {
  running || { echo "Not running" >&2; rm -f "$PIDFILE"; exit 1; }
  kill "$(<"$PIDFILE")"
  rm -f "$PIDFILE"
  echo "Stopped"
}

mkdir -p "$SEEN"

case $1 in
  start)      start ;;
  stop)       stop ;;
  add)        [[ -n $2 ]] || { help; exit 1; }; add "$2" ;;
  remove)     [[ -n $2 ]] || { help; exit 1; }; remove "$2" ;;
  list)       list ;;
  *)          help ;;
esac