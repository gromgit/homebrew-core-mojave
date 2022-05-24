class Nethogs < Formula
  desc "Net top tool grouping bandwidth per process"
  homepage "https://raboof.github.io/nethogs/"
  url "https://github.com/raboof/nethogs/archive/v0.8.7.tar.gz"
  sha256 "957d6afcc220dfbba44c819162f44818051c5b4fb793c47ba98294393986617d"
  license "GPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/nethogs"
    sha256 cellar: :any_skip_relocation, mojave: "893995526f80faa733a6c0361b72ef203297b59f5308c80b8cb5a61b715e59b0"
  end

  uses_from_macos "libpcap"
  uses_from_macos "ncurses"

  def install
    ENV.append "CXXFLAGS", "-std=c++14"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Using -V because other nethogs commands need to be run as root
    system sbin/"nethogs", "-V"
  end
end
