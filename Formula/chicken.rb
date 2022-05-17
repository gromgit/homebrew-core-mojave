class Chicken < Formula
  desc "Compiler for the Scheme programming language"
  homepage "https://www.call-cc.org/"
  url "https://code.call-cc.org/releases/5.3.0/chicken-5.3.0.tar.gz"
  sha256 "c3ad99d8f9e17ed810912ef981ac3b0c2e2f46fb0ecc033b5c3b6dca1bdb0d76"
  license "BSD-3-Clause"
  revision 1
  head "https://code.call-cc.org/git/chicken-core.git", branch: "master"

  livecheck do
    url "https://code.call-cc.org/releases/current/"
    regex(/href=.*?chicken[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/chicken"
    sha256 mojave: "4d6adcce58bcda98d4d1e0d3eba6072c4551572d366575d7f0790dd6af9dcd83"
  end

  def install
    ENV.deparallelize

    args = %W[
      PREFIX=#{prefix}
      C_COMPILER=#{ENV.cc}
      LIBRARIAN=ar
      ARCH=#{Hardware::CPU.arch.to_s.tr("_", "-")}
      LINKER_OPTIONS=-Wl,-rpath,#{rpath},-rpath,#{HOMEBREW_PREFIX}/lib
    ]

    if OS.mac?
      args << "POSTINSTALL_PROGRAM=install_name_tool"
      args << "PLATFORM=macosx"
    else
      args << "PLATFORM=linux"
    end

    system "make", *args
    system "make", "install", *args
  end

  test do
    assert_equal "25", shell_output("#{bin}/csi -e '(print (* 5 5))'").strip
    system bin/"csi", "-ne", "(import (chicken tcp))"
  end
end
