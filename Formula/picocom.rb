class Picocom < Formula
  desc "Minimal dumb-terminal emulation program"
  homepage "https://github.com/npat-efault/picocom"
  url "https://github.com/npat-efault/picocom/archive/3.1.tar.gz"
  sha256 "e6761ca932ffc6d09bd6b11ff018bdaf70b287ce518b3282d29e0270e88420bb"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/picocom"
    sha256 cellar: :any_skip_relocation, mojave: "039291c11406dc539a67eace144367ac5376907b739d589f4cf3c019b4ad1fff"
  end

  # Upstream picocom supports arbitrary baud-rate settings on macOS out of the
  # box, but only applies that to i386 and x86_64 systems. With the advent of
  # arm64 macs, it is now necessary to expand that support.
  # https://github.com/npat-efault/picocom/pull/129
  patch do
    url "https://github.com/npat-efault/picocom/commit/f806bf28266cccdb75ba89d754de8d8fa64c6127.patch?full_index=1"
    sha256 "b1a29265d5b5e0e7e7f8f3194b818802de8c7d18e80525bc43cbb896a6def590"
  end

  def install
    system "make"
    bin.install "picocom"
    man1.install "picocom.1"
  end

  test do
    system "#{bin}/picocom", "--help"
  end
end
