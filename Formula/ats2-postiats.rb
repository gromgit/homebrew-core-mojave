class Ats2Postiats < Formula
  desc "Programming language with formal specification features"
  homepage "http://www.ats-lang.org/"
  url "https://downloads.sourceforge.net/project/ats2-lang/ats2-lang/ats2-postiats-0.4.2/ATS2-Postiats-0.4.2.tgz"
  sha256 "51b8e75e62321f5e3e97d7996d605c46a90c6721b568b9b52fe00c19944134d3"
  license "GPL-3.0-only"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/ATS2-Postiats[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ats2-postiats"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "dcc5ef5e067c9e1767121a5c44b7b27567dffc40b80bdd179d84986407089289"
  end

  depends_on "gmp"

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make", "all", "install"
  end

  test do
    (testpath/"hello.dats").write <<~EOS
      val _ = print ("Hello, world!\n")
      implement main0 () = ()
    EOS
    system "#{bin}/patscc", "hello.dats", "-o", "hello"
    assert_match "Hello, world!", shell_output(testpath/"hello")
  end
end
