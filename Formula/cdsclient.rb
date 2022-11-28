class Cdsclient < Formula
  desc "Tools for querying CDS databases for astronomical data"
  homepage "https://cdsarc.u-strasbg.fr/doc/cdsclient.html"
  url "http://cdsarc.u-strasbg.fr/ftp/pub/sw/cdsclient-3.84.tar.gz"
  sha256 "09eb633011461b9261b923e1d0db69d3591d376b447f316eb1994aaea8919700"
  license "GPL-3.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cdsclient"
    sha256 cellar: :any_skip_relocation, mojave: "e75558ca015f0611fbcd2588b8ad760bdf4699c938dae52be70d3fc709db2e60"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--libdir=#{lib}"
    man.mkpath
    system "make", "install", "MANDIR=#{man}"
    pkgshare.install bin/"abibcode.awk"
  end

  test do
    data = <<~EOS
      12 34 12.5 -34 23 12
      13 24 57.1 +61 12 34
    EOS
    assert_match "#...upload ==>", pipe_output("#{bin}/findgsc - -r 5", data, 0)
  end
end
