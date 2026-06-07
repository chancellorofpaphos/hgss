#!/bin/sh

set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
ORIGINAL_PATH=$PATH
TMP_ROOT=${TMPDIR:-/tmp}/hgss-useful-scripts-tests.$$

passed=0
failed=0

cleanup() {
    rm -rf "$TMP_ROOT"
}
trap cleanup EXIT

fail() {
    printf 'not ok - %s\n' "$1"
    failed=$((failed + 1))
}

pass() {
    printf 'ok - %s\n' "$1"
    passed=$((passed + 1))
}

assert_file_contains() {
    file=$1
    expected=$2
    description=$3

    if grep -Fq -- "$expected" "$file"; then
        pass "$description"
    else
        fail "$description"
        printf '  expected to find: %s\n' "$expected"
        printf '  in file: %s\n' "$file"
        printf '  actual contents:\n'
        sed 's/^/    /' "$file" || true
    fi
}

assert_file_not_contains() {
    file=$1
    unexpected=$2
    description=$3

    if [ ! -e "$file" ]; then
        pass "$description"
        return
    fi

    if grep -Fq -- "$unexpected" "$file"; then
        fail "$description"
        printf '  did not expect to find: %s\n' "$unexpected"
        printf '  in file: %s\n' "$file"
        printf '  actual contents:\n'
        sed 's/^/    /' "$file" || true
    else
        pass "$description"
    fi
}

setup_case() {
    case_name=$1
    CASE_DIR="$TMP_ROOT/$case_name"
    MOCK_BIN="$CASE_DIR/bin"
    WORK_DIR="$CASE_DIR/work"
    LOG_FILE="$CASE_DIR/calls.log"

    mkdir -p "$MOCK_BIN" "$WORK_DIR"
    : > "$LOG_FILE"

    export HGSS_TEST_LOG=$LOG_FILE
    export PATH=$MOCK_BIN:$ORIGINAL_PATH
}

write_ffmpeg_mock() {
    cat > "$MOCK_BIN/ffmpeg" <<'EOF'
#!/bin/sh

printf 'ffmpeg' >> "$HGSS_TEST_LOG"
for arg in "$@"; do
    printf ' <%s>' "$arg" >> "$HGSS_TEST_LOG"
done
printf '\n' >> "$HGSS_TEST_LOG"

previous=
for arg in "$@"; do
    if [ "$previous" = "-i" ] && [ -f "$arg" ]; then
        printf 'input-list-start\n' >> "$HGSS_TEST_LOG"
        sed 's/^/list: /' "$arg" >> "$HGSS_TEST_LOG"
        printf 'input-list-end\n' >> "$HGSS_TEST_LOG"
    fi
    previous=$arg
done
EOF
    chmod +x "$MOCK_BIN/ffmpeg"
}

write_sudo_mock() {
    cat > "$MOCK_BIN/sudo" <<'EOF'
#!/bin/sh

printf 'sudo' >> "$HGSS_TEST_LOG"
for arg in "$@"; do
    printf ' <%s>' "$arg" >> "$HGSS_TEST_LOG"
done
printf '\n' >> "$HGSS_TEST_LOG"

if [ "${1:-}" = "echo" ]; then
    shift
    echo "$@"
fi
EOF
    chmod +x "$MOCK_BIN/sudo"
}

test_reencode_calls_ffmpeg_with_expected_args() {
    setup_case reencode
    write_ffmpeg_mock

    (cd "$WORK_DIR" && sh "$ROOT_DIR/useful_scripts/ffmpeg/reencode.sh")

    assert_file_contains "$LOG_FILE" \
        "ffmpeg <-i> <input.mp4> <-c:v> <libx264> <-crf> <18> <-preset> <slow> <-c:a> <copy> <output.mp4>" \
        "reencode calls ffmpeg with expected arguments"
}

test_hflip_calls_ffmpeg_with_expected_args() {
    setup_case hflip
    write_ffmpeg_mock

    (cd "$WORK_DIR" && sh "$ROOT_DIR/useful_scripts/ffmpeg/hflip.sh")

    assert_file_contains "$LOG_FILE" \
        "ffmpeg <-i> <input.mp4> <-vf> <hflip> <-c:a> <copy> <output.mp4>" \
        "hflip calls ffmpeg with expected arguments"
}

test_cut_calls_ffmpeg_with_expected_args() {
    setup_case cut
    write_ffmpeg_mock

    (cd "$WORK_DIR" && sh "$ROOT_DIR/useful_scripts/ffmpeg/cut.sh")

    assert_file_contains "$LOG_FILE" \
        "ffmpeg <-i> <input.mp4> <-ss> <00:00:00> <-to> <00:00:00> <-c:v> <copy> <-c:a> <copy> <output.mp4>" \
        "cut calls ffmpeg with expected arguments"
}

test_concat_writes_list_and_calls_ffmpeg() {
    setup_case concat
    write_ffmpeg_mock

    (cd "$WORK_DIR" && sh "$ROOT_DIR/useful_scripts/ffmpeg/concat.sh")

    assert_file_contains "$LOG_FILE" \
        "ffmpeg <-f> <concat> <-safe> <0> <-i>" \
        "concat calls ffmpeg in concat mode"
    assert_file_contains "$LOG_FILE" \
        "list: file 'left.mp4'" \
        "concat list includes left input"
    assert_file_contains "$LOG_FILE" \
        "list: file 'right.mp4'" \
        "concat list includes right input"
    assert_file_not_contains "$WORK_DIR/video_list.txt" \
        "file '" \
        "concat does not leave the old fixed video_list.txt behind"
}

test_sfill_no_exits_before_scrub() {
    setup_case sfill_no
    write_sudo_mock

    set +e
    printf 'n\n' | (cd "$WORK_DIR" && sh "$ROOT_DIR/useful_scripts/sfill_current_directoy.sh") > "$CASE_DIR/output.txt" 2>&1
    exit_code=$?
    set -e

    if [ "$exit_code" -ne 0 ]; then
        pass "sfill exits non-zero when confirmation is declined"
    else
        fail "sfill exits non-zero when confirmation is declined"
    fi
    assert_file_not_contains "$LOG_FILE" \
        "sudo <sfill> <.>" \
        "sfill does not scrub when confirmation is declined"
}

test_sfill_yes_runs_scrub() {
    setup_case sfill_yes
    write_sudo_mock

    printf 'y\n' | (cd "$WORK_DIR" && sh "$ROOT_DIR/useful_scripts/sfill_current_directoy.sh") > "$CASE_DIR/output.txt" 2>&1

    assert_file_contains "$LOG_FILE" \
        "sudo <sfill> <.>" \
        "sfill scrubs current directory when confirmation is accepted"
}

test_reencode_calls_ffmpeg_with_expected_args
test_hflip_calls_ffmpeg_with_expected_args
test_cut_calls_ffmpeg_with_expected_args
test_concat_writes_list_and_calls_ffmpeg
test_sfill_no_exits_before_scrub
test_sfill_yes_runs_scrub

printf '\n%d passed, %d failed\n' "$passed" "$failed"

if [ "$failed" -ne 0 ]; then
    exit 1
fi
