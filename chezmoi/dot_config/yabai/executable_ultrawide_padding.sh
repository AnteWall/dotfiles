#!/usr/bin/env bash

# Dynamic padding for ultrawide monitors.
# 1-3 windows: each window targets ~1/4 screen width, centered with generous padding.
# 4   windows: padding drops to normal, split into equal columns.
# 5+  windows: normal BSP, inserting new windows into the rightmost tile.

ULTRAWIDE_THRESHOLD=3000  # display width (points) to qualify as ultrawide
MIN_PADDING=600           # minimum side padding for 1-3 windows
NORMAL_PADDING=8          # padding for 4+ windows / non-ultrawide
UW_VERTICAL_PADDING=60    # top/bottom padding for 1-4 windows
NORMAL_VERTICAL_PADDING=8 # top/bottom padding for 4+ windows
WINDOW_GAP=10             # keep in sync with yabairc window_gap

# Coalesce event storms. Window creation/destruction often emits multiple
# signals; overlapping layout scripts make animations feel sluggish.
LOCK_DIR="${TMPDIR:-/tmp}/yabai-ultrawide-padding.lock"
if ! mkdir "$LOCK_DIR" 2>/dev/null; then
  exit 0
fi
trap 'rmdir "$LOCK_DIR"' EXIT

# Small delay so yabai finishes tiling before we query
sleep 0.03

# ── Gather state ────────────────────────────────────────────────

SPACE_JSON=$(yabai -m query --spaces --space 2>/dev/null) || exit 0
SPACE=$(echo "$SPACE_JSON" | jq -r '.index')

DISPLAY_WIDTH=$(yabai -m query --displays --display 2>/dev/null \
  | jq -r '.frame.w | floor')

WINDOWS_JSON=$(yabai -m query --windows --space "$SPACE" 2>/dev/null) || exit 0

# Count only visible tiled windows and track which side the widest leaf sits on.
IFS="$(printf '\t')" read -r WINDOW_COUNT LARGEST_CHILD <<EOF
$(echo "$WINDOWS_JSON" | jq -r '
  [.[] | select(."root-window" == true
               and ."is-visible" == true
               and ."is-floating" == false
               and ."is-minimized" == false
               and ."is-hidden" == false)] as $windows
  | [($windows | length), (($windows | max_by(.frame.w) | ."split-child") // "none")]
  | @tsv
')
EOF

# ── Apply layout ───────────────────────────────────────────────

if [ "$DISPLAY_WIDTH" -ge "$ULTRAWIDE_THRESHOLD" ] \
   && [ "$WINDOW_COUNT" -ge 1 ] \
   && [ "$WINDOW_COUNT" -le 3 ]; then

  TARGET_WIDTH=$((DISPLAY_WIDTH / 4))
  TOTAL_GAPS=$(( (WINDOW_COUNT - 1) * WINDOW_GAP ))
  NEEDED=$((WINDOW_COUNT * TARGET_WIDTH + TOTAL_GAPS))
  PADDING=$(( (DISPLAY_WIDTH - NEEDED) / 2 ))

  [ "$PADDING" -lt "$MIN_PADDING" ] && PADDING=$MIN_PADDING

  yabai -m config window_insertion_point last
  yabai -m config --space "$SPACE" split_type vertical

  yabai -m space "$SPACE" --padding abs:"$UW_VERTICAL_PADDING":"$UW_VERTICAL_PADDING":"$PADDING":"$PADDING"

  if [ "$WINDOW_COUNT" -eq 2 ]; then
    # Keep both windows at the same width inside the 1/4-width target area.
    yabai -m window largest --ratio abs:0.5
  elif [ "$WINDOW_COUNT" -eq 3 ]; then
    # Make the oversized single leaf 1/3 wide. The correct root ratio depends
    # on whether that leaf sits on the left or right side of the root split.
    if [ "$LARGEST_CHILD" = "first_child" ]; then
      yabai -m window largest --ratio abs:0.3333
    else
      yabai -m window largest --ratio abs:0.6667
    fi
  fi
elif [ "$DISPLAY_WIDTH" -ge "$ULTRAWIDE_THRESHOLD" ] \
     && [ "$WINDOW_COUNT" -eq 4 ]; then
  yabai -m config window_insertion_point last
  yabai -m space "$SPACE" --padding abs:"$UW_VERTICAL_PADDING":"$UW_VERTICAL_PADDING":"$NORMAL_PADDING":"$NORMAL_PADDING"

  # Four windows should be true 25% columns before normal BSP takes over at 5+.
  # This works when the fourth window was inserted while the 1-3 mode had
  # split_type=vertical, producing ((A, B), (C, D)).
  yabai -m space --balance x-axis
  yabai -m config --space "$SPACE" split_type auto
else
  yabai -m config window_insertion_point last
  yabai -m config --space "$SPACE" split_type auto
  yabai -m space "$SPACE" --padding abs:"$NORMAL_VERTICAL_PADDING":"$NORMAL_VERTICAL_PADDING":"$NORMAL_PADDING":"$NORMAL_PADDING"
fi
