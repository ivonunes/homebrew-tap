class Plumekit < Formula
  desc "Delightful Swift web framework that runs anywhere"
  homepage "https://plumekit.dev"
  version "3.1.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ivonunes/plumekit/releases/download/v3.1.2/plumekit-v3.1.2-macos-arm64.tar.gz"
      sha256 "1d01100a714af3dd0a103bcdcef20a7c1273e0dfd90f439d7f99683ddd98c021"
    else
      url "https://github.com/ivonunes/plumekit/releases/download/v3.1.2/plumekit-v3.1.2-macos-x86_64.tar.gz"
      sha256 "c1b0b099337d5a036118b20b194e7ebcf0ea1c8b042628db925f123405ac2e95"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ivonunes/plumekit/releases/download/v3.1.2/plumekit-v3.1.2-linux-arm64.tar.gz"
      sha256 "f2f1ee58704f2daec846cd70c58280cc91806b17c9bf61511beff3ed68b1e379"
    else
      url "https://github.com/ivonunes/plumekit/releases/download/v3.1.2/plumekit-v3.1.2-linux-x86_64.tar.gz"
      sha256 "31809cde2643c91477c220226e804d760b783858b2e25300df00d40b64151475"
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
