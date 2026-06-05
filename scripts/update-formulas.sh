#!/bin/sh
set -eu

root="${HOMEBREW_TAP_ROOT:-$(CDPATH= cd "$(dirname "$0")/.." && pwd)}"
formula_dir="$root/Formula"
mkdir -p "$formula_dir"

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

render_writer_formula() {
    repo="ivonunes/inkstead-writer"
    tag="$(latest_tag "$repo")"
    if [ -z "$tag" ]; then
        echo "No Inkstead Writer release found; leaving formula unchanged."
        return
    fi

    checksums="$(mktemp "${TMPDIR:-/tmp}/inkstead-writer-checksums.XXXXXX")"
    trap 'rm -f "$checksums"' EXIT HUP INT TERM
    download_checksums "$repo" "$tag" "$checksums" inkstead-writer

    launcher="inkstead-writer-$tag"
    launcher_sha="$(checksum_for "$checksums" "$launcher")"
    require_checksum "$launcher_sha" "$launcher"
    version="${tag#v}"

    cat > "$formula_dir/inkstead-writer.rb" <<FORMULA
class InksteadWriter < Formula
  desc "Launcher for Inkstead Writer personal website publishing"
  homepage "https://inkstead.dev/writer"
  url "https://github.com/$repo/releases/download/$tag/$launcher",
      using: :nounzip
  sha256 "$launcher_sha"
  version "$version"
  license "MIT"

  def install
    bin.install cached_download => "inkstead-writer"
  end

  test do
    assert_match "Inkstead Writer launcher", shell_output("#{bin}/inkstead-writer --help")
  end
end
FORMULA

    rm -f "$checksums"
    trap - EXIT HUP INT TERM
    echo "Updated Formula/inkstead-writer.rb to $tag"
}

render_plume_formula() {
    repo="ivonunes/plume"
    tag="$(latest_tag "$repo")"
    if [ -z "$tag" ]; then
        echo "No Plume release found; leaving formula unchanged."
        return
    fi

    checksums="$(mktemp "${TMPDIR:-/tmp}/plume-checksums.XXXXXX")"
    trap 'rm -f "$checksums"' EXIT HUP INT TERM
    download_checksums "$repo" "$tag" "$checksums" plume

    macos_arm64_asset="plume-$tag-macos-arm64.tar.gz"
    macos_x86_64_asset="plume-$tag-macos-x86_64.tar.gz"
    linux_arm64_asset="plume-$tag-linux-arm64.tar.gz"
    linux_x86_64_asset="plume-$tag-linux-x86_64.tar.gz"

    macos_arm64="$(checksum_for "$checksums" "$macos_arm64_asset")"
    macos_x86_64="$(checksum_for "$checksums" "$macos_x86_64_asset")"
    linux_arm64="$(checksum_for "$checksums" "$linux_arm64_asset")"
    linux_x86_64="$(checksum_for "$checksums" "$linux_x86_64_asset")"

    require_checksum "$macos_arm64" "$macos_arm64_asset"
    require_checksum "$macos_x86_64" "$macos_x86_64_asset"
    require_checksum "$linux_arm64" "$linux_arm64_asset"
    require_checksum "$linux_x86_64" "$linux_x86_64_asset"

    version="${tag#v}"

    cat > "$formula_dir/plume.rb" <<FORMULA
class Plume < Formula
  desc "Templating language for building expressive websites"
  homepage "https://inkstead.dev/plume"
  version "$version"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/$repo/releases/download/$tag/$macos_arm64_asset"
      sha256 "$macos_arm64"
    else
      url "https://github.com/$repo/releases/download/$tag/$macos_x86_64_asset"
      sha256 "$macos_x86_64"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/$repo/releases/download/$tag/$linux_arm64_asset"
      sha256 "$linux_arm64"
    else
      url "https://github.com/$repo/releases/download/$tag/$linux_x86_64_asset"
      sha256 "$linux_x86_64"
    end
  end

  def install
    bin.install "plume"
    prefix.install "LICENSE.txt" if File.exist?("LICENSE.txt")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plume version")
    (testpath/"sample.plume").write("@let title = \\"Hello\\"\\n<h1>{ title }</h1>\\n")
    assert_match "Plume check passed", shell_output("#{bin}/plume check #{testpath}")
  end
end
FORMULA

    rm -f "$checksums"
    trap - EXIT HUP INT TERM
    echo "Updated Formula/plume.rb to $tag"
}

render_writer_formula
render_plume_formula
