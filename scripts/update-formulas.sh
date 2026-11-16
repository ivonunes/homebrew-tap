#!/bin/sh
set -eu

root="${HOMEBREW_TAP_ROOT:-$(CDPATH= cd "$(dirname "$0")/.." && pwd)}"
cask_dir="$root/Casks"

github_get() {
    url="$1"
    if [ -n "${GITHUB_TOKEN:-}" ]; then
        curl -fsSL \
            -H "Accept: application/vnd.github+json" \
            -H "Authorization: Bearer $GITHUB_TOKEN" \
            -H "X-GitHub-Api-Version: 2022-11-28" \
            "$url"
    else
        curl -fsSL \
            -H "Accept: application/vnd.github+json" \
            -H "X-GitHub-Api-Version: 2022-11-28" \
            "$url"
    fi
}

latest_tag() {
    repo="$1"
    if [ -n "${HOMEBREW_TAP_FIXTURES_DIR:-}" ]; then
        owner="${repo%%/*}"
        name="${repo#*/}"
        tag_file="$HOMEBREW_TAP_FIXTURES_DIR/$owner/$name/tag"
        [ -f "$tag_file" ] || return 0
        sed -n '1p' "$tag_file"
        return
    fi

    response="$(github_get "https://api.github.com/repos/$repo/releases/latest" 2>/dev/null || true)"
    printf '%s\n' "$response" |
        sed -n 's/.*"tag_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' |
        sed -n '1p'
}

download_checksums() {
    repo="$1"
    tag="$2"
    output="$3"
    prefix="$4"
    checksum_asset="$prefix-$tag-SHA256SUMS"
    if [ -n "${HOMEBREW_TAP_FIXTURES_DIR:-}" ]; then
        owner="${repo%%/*}"
        name="${repo#*/}"
        cp "$HOMEBREW_TAP_FIXTURES_DIR/$owner/$name/$checksum_asset" "$output"
        return
    fi

    github_get "https://github.com/$repo/releases/download/$tag/$checksum_asset" > "$output"
}

checksum_for() {
    file="$1"
    name="$2"
    awk -v name="$name" '$2 == name { print $1 }' "$file"
}

require_checksum() {
    checksum="$1"
    asset="$2"
    [ -n "$checksum" ] || {
        echo "Missing checksum for $asset" >&2
        exit 1
    }
}

render_wheelio_cask() {
    repo="ivonunes/wheelio"
    tag="$(latest_tag "$repo")"
    if [ -z "$tag" ]; then
        echo "No Wheelio release found; leaving cask unchanged."
        return
    fi

    checksums="$(mktemp "${TMPDIR:-/tmp}/wheelio-checksums.XXXXXX")"
    trap 'rm -f "$checksums"' EXIT HUP INT TERM
    # Releases before 2.0.0 publish no checksums file (and weren't signed),
    # so there's nothing to build a cask from yet.
    if ! download_checksums "$repo" "$tag" "$checksums" wheelio; then
        echo "No Wheelio checksums for $tag yet; leaving cask unchanged."
        rm -f "$checksums"; trap - EXIT HUP INT TERM
        return
    fi

    version="${tag#v}"
    asset="wheelio-$version.zip"
    sha="$(checksum_for "$checksums" "$asset")"
    require_checksum "$sha" "$asset"

    mkdir -p "$cask_dir"
    cat > "$cask_dir/wheelio.rb" <<CASK
cask "wheelio" do
  version "$version"
  sha256 "$sha"

  url "https://github.com/$repo/releases/download/v#{version}/wheelio-#{version}.zip"
  name "Wheelio"
  desc "Play Windows driving games from Steam with force feedback wheels and VR"
  homepage "https://github.com/$repo"

  depends_on arch: :arm64
  depends_on macos: :sequoia

  app "wheelio-#{version}/Wheelio.app"

  uninstall quit: "uk.ivonunes.wheelio"

  # Not Application Support/Wheelio/Steam: it holds the library Steam loads
  # while Steam Play is on, and Valve's copy of Steam.app to put back.
  zap trash: [
    "~/Library/Application Support/Wheelio/Engine",
    "~/Library/Application Support/Wheelio/GamePortingToolkit",
    "~/Library/Caches/uk.ivonunes.wheelio",
    "~/Library/HTTPStorages/uk.ivonunes.wheelio",
    "~/Library/Preferences/uk.ivonunes.wheelio.plist",
  ]

  caveats <<~EOS
    Before uninstalling, turn off Play Windows games in Steam in Wheelio's
    Settings, so it puts Valve's own Steam back.
  EOS
end
CASK

    rm -f "$checksums"
    trap - EXIT HUP INT TERM
    echo "Updated Casks/wheelio.rb to $tag"
}

render_wheelio_cask
