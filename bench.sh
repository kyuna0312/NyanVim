#!/usr/bin/env bash
# bench.sh — NyanVim startup time benchmark
# Usage: ./bench.sh [--runs N] [--version VER] [--threshold PCT]
set -euo pipefail

RUNS=10
VERSION=$(git describe --tags --always 2>/dev/null || echo "dev")
THRESHOLD=10
REPO_ROOT=$(git rev-parse --show-toplevel)
OUT_DIR="${REPO_ROOT}/docs/perf"
DATE=$(date +%Y-%m-%d)

if ! command -v nvim &>/dev/null; then
  echo "error: nvim not found in PATH" >&2
  exit 1
fi

while [[ $# -gt 0 ]]; do
  case $1 in
    --runs)      RUNS="$2";      shift 2 ;;
    --version)   VERSION="$2";   shift 2 ;;
    --threshold) THRESHOLD="$2"; shift 2 ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
done

if ! [[ "$RUNS" =~ ^[0-9]+$ ]] || [[ "$RUNS" -lt 1 ]]; then
  echo "error: --runs must be a positive integer" >&2
  exit 1
fi

OUT_FILE="${OUT_DIR}/${DATE}-${VERSION}.md"
mkdir -p "$OUT_DIR"

echo "Benchmarking NyanVim startup ($RUNS runs)..."
times=()
for i in $(seq 1 "$RUNS"); do
  printf "  run %d/%d\r" "$i" "$RUNS"
  TMP=$(mktemp)
  nvim --startuptime "$TMP" --headless -c "qa" 2>/dev/null
  t=$(grep "NVIM STARTED" "$TMP" | awk '{print $1}')
  rm -f "$TMP"
  if [[ -z "$t" ]]; then
    echo "error: failed to parse startup time on run $i" >&2
    exit 1
  fi
  times+=("$t")
done
echo ""

# Compute mean, median, min, max via sort + awk
if [[ "${#times[@]}" -eq 0 ]]; then
  echo "error: no timing results collected" >&2
  exit 1
fi
read -r MEAN MEDIAN MIN MAX < <(
  printf '%s\n' "${times[@]}" | sort -n | awk -v n="${#times[@]}" '
  { a[NR] = $1; sum += $1 }
  END {
    mean = sum / n
    if (n % 2 == 1) median = a[int(n/2) + 1]
    else             median = (a[n/2] + a[n/2 + 1]) / 2
    printf "%.3f %.3f %.3f %.3f\n", mean, median, a[1], a[n]
  }'
)

# Regression detection: compare mean vs most recent previous result
PREV_MEAN=""
PREV_VERSION=""
REGRESSION_MSG=""

prev_file=$(ls -1t "${OUT_DIR}"/*.md 2>/dev/null | grep -v "${OUT_FILE}" | head -1 || true)
if [[ -n "$prev_file" ]]; then
  PREV_MEAN=$(grep "^<!-- nyanvim-perf:" "$prev_file" \
    | sed 's/.*mean=\([0-9.]*\).*/\1/' || true)
  PREV_VERSION=$(grep "^<!-- nyanvim-perf:" "$prev_file" \
    | sed 's/.*version=\([^ ]*\).*/\1/' || true)
fi

if [[ -n "$PREV_MEAN" ]]; then
  delta_pct=$(awk "BEGIN { printf \"%.1f\", ($MEAN - $PREV_MEAN) / $PREV_MEAN * 100 }")
  is_regression=$(awk "BEGIN { print ($delta_pct + 0 > $THRESHOLD + 0) ? 1 : 0 }")
  if [[ "$is_regression" == "1" ]]; then
    REGRESSION_MSG="REGRESSION: +${delta_pct}% vs ${PREV_VERSION} (threshold: ${THRESHOLD}%)"
    echo "⚠️  $REGRESSION_MSG" >&2
  fi
fi

# Write markdown report
{
  printf '<!-- nyanvim-perf: mean=%s median=%s min=%s max=%s runs=%s version=%s date=%s -->\n' \
    "$MEAN" "$MEDIAN" "$MIN" "$MAX" "$RUNS" "$VERSION" "$DATE"
  echo ""
  echo "## NyanVim Startup Performance: ${VERSION} (${DATE})"
  echo ""
  echo "| Metric | Value |"
  echo "|--------|-------|"
  echo "| Mean   | ${MEAN}ms |"
  echo "| Median | ${MEDIAN}ms |"
  echo "| Min    | ${MIN}ms |"
  echo "| Max    | ${MAX}ms |"
  echo "| Runs   | ${RUNS} |"
  echo ""
  if [[ -n "$PREV_MEAN" ]]; then
    delta_pct=$(awk "BEGIN { printf \"%.1f\", ($MEAN - $PREV_MEAN) / $PREV_MEAN * 100 }")
    if awk "BEGIN { exit ($delta_pct + 0 > 0) ? 0 : 1 }"; then
      badge="🔴"
    else
      badge="🟢"
    fi
    echo "### vs. ${PREV_VERSION}"
    echo ""
    echo "| Before | After | Delta |"
    echo "|--------|-------|-------|"
    echo "| ${PREV_MEAN}ms | ${MEAN}ms | ${badge} ${delta_pct}% |"
    echo ""
  fi
  printf '_Measured with `nvim --startuptime` on %s %s_\n' "$(uname -s)" "$(uname -m)"
} > "$OUT_FILE"

echo "Mean: ${MEAN}ms  Median: ${MEDIAN}ms  Min: ${MIN}ms  Max: ${MAX}ms"
echo "Saved: $OUT_FILE"

# Exit 2 on regression so CI can detect it
if [[ -n "$REGRESSION_MSG" ]]; then
  exit 2
fi
