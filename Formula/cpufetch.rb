class Cpufetch < Formula
  desc "CPU architecture fetching tool"
  homepage "https://github.com/Dr-Noob/cpufetch"
  url "https://github.com/Dr-Noob/cpufetch/archive/v1.02.tar.gz"
  sha256 "3d1c80aba3daa5fe300b6de6e06d9030f97b7be5210f8ea4110de733ea4373f8"
  license "GPL-2.0"
  head "https://github.com/Dr-Noob/cpufetch.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cpufetch"
    sha256 cellar: :any_skip_relocation, mojave: "39938edef1b5a10a751d20c83bc49f4f47a8198b93d4bc8cd8076a545f9a81e5"
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
