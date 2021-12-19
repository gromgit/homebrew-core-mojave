class Austin < Formula
  desc "Python frame stack sampler for CPython"
  homepage "https://github.com/P403n1x87/austin"
  url "https://github.com/P403n1x87/austin/archive/v3.2.0.tar.gz"
  sha256 "ee189af905fac77ff9173b57d8e927bdb7c4cf5e18b1bfd7f4456ac46fe04484"
  license "GPL-3.0-or-later"
  head "https://github.com/P403n1x87/austin.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/austin"
    sha256 cellar: :any_skip_relocation, mojave: "0ca432108853bf1633449acf81940f1f43dfe137b8d165c9ccbee9d8b138e32f"
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
