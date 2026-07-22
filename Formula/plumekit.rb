class Plumekit < Formula
  desc "Delightful Swift web framework that runs anywhere"
  homepage "https://plumekit.dev"
  version "3.1.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ivonunes/plumekit/releases/download/v3.1.1/plumekit-v3.1.1-macos-arm64.tar.gz"
      sha256 "3a6a8312e633c3d08f4182df02a9b329ef7af09b780fa5030922a4874a49a37e"
    else
      url "https://github.com/ivonunes/plumekit/releases/download/v3.1.1/plumekit-v3.1.1-macos-x86_64.tar.gz"
      sha256 "78146a46d22d51d40fcebb5cdfacf3e9bcaedd05458291a4da6973af7fc15a74"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ivonunes/plumekit/releases/download/v3.1.1/plumekit-v3.1.1-linux-arm64.tar.gz"
      sha256 "5bd6f9cc944e6d031569acfc421ce5079b458f66da7ec6a24feebb0a0ffec66b"
    else
      url "https://github.com/ivonunes/plumekit/releases/download/v3.1.1/plumekit-v3.1.1-linux-x86_64.tar.gz"
      sha256 "a646367bd8d75aa3a988ec5553f3126705e1c295db8fb86dd7aee1d788227505"
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
