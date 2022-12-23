class Austin < Formula
  desc "Python frame stack sampler for CPython"
  homepage "https://github.com/P403n1x87/austin"
  url "https://github.com/P403n1x87/austin/archive/v3.4.1.tar.gz"
  sha256 "e668af1172f0c2f8740bd7d2eed6613e916e97a7cc88aa6b0cf8420055c2bcc1"
  license "GPL-3.0-or-later"
  head "https://github.com/P403n1x87/austin.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/austin"
    sha256 cellar: :any_skip_relocation, mojave: "447617e3bcfd434b8790e07433b0ce306801823f5b5e5b9f3a5a99dfa550089f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python@3.11" => :test

  def install
    system "autoreconf", "--install"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
    man1.install "src/austin.1"
  end

  test do
    python3 = "python3.11"
    shell_output(bin/"austin #{python3} -c \"from time import sleep; sleep(1)\"", 37)
  end
end
