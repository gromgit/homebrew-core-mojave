class Austin < Formula
  desc "Python frame stack sampler for CPython"
  homepage "https://github.com/P403n1x87/austin"
  url "https://github.com/P403n1x87/austin/archive/v3.3.0.tar.gz"
  sha256 "a0dcfee0dffecb00b85a84f3c7befff7e61fd4b504228c1e6ce7bc5af9790506"
  license "GPL-3.0-or-later"
  head "https://github.com/P403n1x87/austin.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/austin"
    sha256 cellar: :any_skip_relocation, mojave: "b5bb482e94a0e9a2b606ded388d1e4721d2c866711ce0fdea6ea58b12c0c104f"
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
    shell_output(bin/"austin #{Formula["python@3.10"].opt_bin}/python3 -c \"from time import sleep; sleep(1)\"", 37)
  end
end
