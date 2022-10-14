class Mtools < Formula
  desc "Tools for manipulating MSDOS files"
  homepage "https://www.gnu.org/software/mtools/"
  url "https://ftp.gnu.org/gnu/mtools/mtools-4.0.41.tar.gz"
  mirror "https://ftpmirror.gnu.org/mtools/mtools-4.0.41.tar.gz"
  sha256 "0816539dd3784fdf622de90aa5459d7c897584d69930a076b38fc4e975bd63d3"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mtools"
    sha256 cellar: :any_skip_relocation, mojave: "a9f93e6bd1781501a082530d2e5054698b7b30bb16bde59f547c4219016e1206"
  end

  conflicts_with "multimarkdown", because: "both install `mmd` binaries"

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --without-x
    ]
    args << "LIBS=-liconv" if OS.mac?

    # The mtools configure script incorrectly detects stat64. This forces it off
    # to fix build errors on Apple Silicon. See stat(6) and pv.rb.
    ENV["ac_cv_func_stat64"] = "no" if Hardware::CPU.arm?

    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mtools --version")
  end
end
