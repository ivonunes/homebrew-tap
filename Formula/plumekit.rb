class Plumekit < Formula
  desc "Delightful Swift web framework that runs anywhere"
  homepage "https://plumekit.dev"
  version "2.0.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ivonunes/plumekit/releases/download/v2.0.2/plumekit-v2.0.2-macos-arm64.tar.gz"
      sha256 "0dc4a70b5a3669e60171b241b4c0311c9a6b2281e2c03e725fc948710d799723"
    else
      url "https://github.com/ivonunes/plumekit/releases/download/v2.0.2/plumekit-v2.0.2-macos-x86_64.tar.gz"
      sha256 "3e7fece3174a80e0dd333a8dff4fab58586e18760ead21e5bedc88b0ff28d9bc"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ivonunes/plumekit/releases/download/v2.0.2/plumekit-v2.0.2-linux-arm64.tar.gz"
      sha256 "bc5d61c666921c6f78531f3d58b44d3ba945bf8422da1d12f8f33ec4e90bdf9b"
    else
      url "https://github.com/ivonunes/plumekit/releases/download/v2.0.2/plumekit-v2.0.2-linux-x86_64.tar.gz"
      sha256 "224dd2f66488be85cabf0a524da398204eba28bcce8ffae5fbc48f34b26f0f5d"
    end
  end

  def install
    bin.install "plumekit"
    prefix.install "LICENSE.txt" if File.exist?("LICENSE.txt")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plumekit version")
    (testpath/"sample.plume").write("@let title = \"Hello\"\n<h1>{ title }</h1>\n")
    assert_match "Plume check passed", shell_output("#{bin}/plumekit check #{testpath}")
  end
end
