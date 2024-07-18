#!/bin/sh

set -oue pipefail

EXTRA_ARGS=()

# Additional args for enabling Wayland
if [[ "${XDG_SESSION_TYPE}" == "wayland" ]]; then
    EXTRA_ARGS+=(
        "--enable-features=UseOzonePlatform"
        "--ozone-platform-hint=auto"
        "--ozone-platform=wayland"
    )
fi

export FLATPAK_ID="${FLATPAK_ID:-com.beeper.Beeper}"
export TMPDIR="${XDG_RUNTIME_DIR}/app/${FLATPAK_ID}"

exec zypak-wrapper /app/beeper/beeper "${EXTRA_ARGS[@]}" "$@"
