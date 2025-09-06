#!/usr/bin/env bash
set -Eeuo pipefail

# Verifies key live URLs after deploy.
# Usage: BASE_URL=https://example.com bash scripts/verify-site.sh

BASE_URL="${BASE_URL:-https://spectrumsyntax.netlify.app}"

fetch() {
  curl -sS -L --max-time 20 "$1"
}

head_req() {
  curl -sSI --max-time 20 "$1"
}

section_nav_dropdown() {
  # Extract only the Rockhounding dropdown nav to avoid false positives elsewhere
  fetch "$BASE_URL/rockhounding/" | awk '/id="nav-dropdown-rockhounding"/,/<\/ul>/'
}

assert_absent() {
  local content="$1" pattern="$2" where="$3"
  if echo "$content" | grep -Fq "$pattern"; then
    echo "[FAIL] Unexpected presence of '$pattern' in $where"
    return 1
  else
    echo "[OK] Absent in $where: $pattern"
  fi
}

assert_present() {
  local content="$1" pattern="$2" where="$3"
  if echo "$content" | grep -Fq "$pattern"; then
    echo "[OK] Present in $where: $pattern"
  else
    echo "[FAIL] Missing '$pattern' in $where"
    return 1
  fi
}

check_redirect() {
  local from="$1" expect_loc="$2"
  local headers status location
  headers=$(head_req "$from") || { echo "[FAIL] HEAD $from"; return 1; }
  status=$(printf "%s" "$headers" | awk 'tolower($1) ~ /^http\// {print $2; exit}')
  location=$(printf "%s" "$headers" | awk 'tolower($1) == "location:" {print $2; exit}' | tr -d '\r')
  if [[ "$status" != "301" && "$status" != "302" ]]; then
    echo "[FAIL] Expected redirect for $from, got $status"
    return 1
  fi
  if [[ "$location" != "$expect_loc" ]]; then
    echo "[FAIL] Redirect location mismatch for $from: got '$location', want '$expect_loc'"
    return 1
  fi
  echo "[OK] Redirect $from -> $location ($status)"
}

run_checks_once() {
  local failures=0

  # Rockhounding index body
  body=$(fetch "$BASE_URL/rockhounding/") || { echo "[FAIL] Fetch rockhounding index"; return 1; }

  # Quick Links must be absent
  assert_absent "$body" "Quick Links" "/rockhounding/" || failures=$((failures+1))

  # Nav dropdown should not include Field Log or Tumbling
  nav=$(section_nav_dropdown)
  assert_absent "$nav" "/rockhounding/field-log/" "nav-dropdown-rockhounding" || failures=$((failures+1))
  assert_absent "$nav" "/rockhounding/tumbling/" "nav-dropdown-rockhounding" || failures=$((failures+1))

  # Redirect from old Tumbling path
  check_redirect "$BASE_URL/tumbling/" "/rockhounding/tumbling/" || failures=$((failures+1))

  # New Tumbling page exists
  tumble=$(fetch "$BASE_URL/rockhounding/tumbling/") || { echo "[FAIL] Fetch tumbling"; failures=$((failures+1)); }
  if [[ -n "$tumble" ]]; then
    assert_present "$tumble" "<h1>Tumbling</h1>" "/rockhounding/tumbling/" || failures=$((failures+1))
  fi

  return $failures
}

# Retry a few times in case CDN is catching up
attempts=10
sleep_s=6
for i in $(seq 1 "$attempts"); do
  echo "--- Verification attempt $i/$attempts against $BASE_URL"
  if run_checks_once; then
    echo "All checks passed"
    exit 0
  fi
  echo "Checks failing; retrying in ${sleep_s}s..."
  sleep "$sleep_s"
done

echo "Verification failed after $attempts attempts"
exit 1
