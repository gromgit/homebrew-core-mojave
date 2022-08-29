class Austin < Formula
  desc "Python frame stack sampler for CPython"
  homepage "https://github.com/P403n1x87/austin"
  url "https://github.com/P403n1x87/austin/archive/v3.3.0.tar.gz"
  sha256 "a0dcfee0dffecb00b85a84f3c7befff7e61fd4b504228c1e6ce7bc5af9790506"
  license "GPL-3.0-or-later"
  head "https://github.com/P403n1x87/austin.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/austin"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "4c128cc47040dfc6448fb280f3e5015de0134a6fcb5c8c724d10ec1392cf9608"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python@3.10" => :test

  def install
    system "autoreconf", "--install"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    man1.install "src/austin.1"
  end

  test do
    python = Formula["python@3.10"].opt_bin/"python3.10"
    shell_output(bin/"austin #{python} -c \"from time import sleep; sleep(1)\"", 37)
  end
end
