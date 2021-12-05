class Cpufetch < Formula
  desc "CPU architecture fetching tool"
  homepage "https://github.com/Dr-Noob/cpufetch"
  url "https://github.com/Dr-Noob/cpufetch/archive/v1.01.tar.gz"
  sha256 "d4fe25adc4d12f5f1dc7a7e70a4ed92e9807b6a1ad0294c563a0250f7bd6aca1"
  license "MIT"
  head "https://github.com/Dr-Noob/cpufetch.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cpufetch"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "c94a045bc81661fa777a00f1ad459b56a8078c114a2756e75035875086fc193e"
  end

  def install
    system "make"
    bin.install "cpufetch"
    man1.install "cpufetch.1"
  end

  test do
    actual = shell_output("#{bin}/cpufetch -d").each_line.first.strip

    expected = if OS.linux?
      "cpufetch v#{version} (Linux #{Hardware::CPU.arch} build)"
    elsif Hardware::CPU.arm?
      "cpufetch v#{version} (macOS ARM build)"
    else
      "cpufetch is computing APIC IDs, please wait..."
    end

    assert_equal expected, actual
  end
end
