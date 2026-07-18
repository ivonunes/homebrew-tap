class Plumekit < Formula
  desc "Delightful Swift web framework that runs anywhere"
  homepage "https://plumekit.dev"
  version "2.1.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ivonunes/plumekit/releases/download/v2.1.1/plumekit-v2.1.1-macos-arm64.tar.gz"
      sha256 "4cc24417773eaaf2114d0140e82142bff124ca6ddd3de435bcbfc3f9ac82bd39"
    else
      url "https://github.com/ivonunes/plumekit/releases/download/v2.1.1/plumekit-v2.1.1-macos-x86_64.tar.gz"
      sha256 "f59def07e086d3b4a7be67c735eb7937ac799cfc4511ac1d9f91e744ac73720a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ivonunes/plumekit/releases/download/v2.1.1/plumekit-v2.1.1-linux-arm64.tar.gz"
      sha256 "d0e18e5e2f508455a8af095d851e352ba62d45c1dd571dbd561436f944de2bd9"
    else
      url "https://github.com/ivonunes/plumekit/releases/download/v2.1.1/plumekit-v2.1.1-linux-x86_64.tar.gz"
      sha256 "bea7c28b1617b82fd3de2ae1914fcaee30ed5b08e99fb5489a3c86022dab9cc1"
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
