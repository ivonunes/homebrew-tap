class Plumekit < Formula
  desc "Delightful Swift web framework that runs anywhere"
  homepage "https://plumekit.dev"
  version "3.1.3"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ivonunes/plumekit/releases/download/v3.1.3/plumekit-v3.1.3-macos-arm64.tar.gz"
      sha256 "6ecde4d2438dfb2f127433f1fdb9373cccd87350a05e36fe00b5a6d9a0471025"
    else
      url "https://github.com/ivonunes/plumekit/releases/download/v3.1.3/plumekit-v3.1.3-macos-x86_64.tar.gz"
      sha256 "63e597fcdfeacc13de1034440d66bb2fc73bb5e0b575e3044bb0494542422699"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ivonunes/plumekit/releases/download/v3.1.3/plumekit-v3.1.3-linux-arm64.tar.gz"
      sha256 "e6da45bca06f7363fc879349fe46c6d673f30fe6e3760da7918d3c982489a83e"
    else
      url "https://github.com/ivonunes/plumekit/releases/download/v3.1.3/plumekit-v3.1.3-linux-x86_64.tar.gz"
      sha256 "4d468bb3a7e5209edd40fcfc05d2a3311b84259500aea3d6cc1d3f502f90e591"
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
