class Openfst < Formula
  desc "Library for weighted finite-state transducers"
  homepage "https://www.openfst.org/twiki/bin/view/FST/WebHome"
  url "https://openfst.org/twiki/pub/FST/FstDownload/openfst-1.8.2.tar.gz"
  sha256 "de987bf3624721c5d5ba321af95751898e4f4bb41c8a36e2d64f0627656d8b42"
  license "Apache-2.0"

  livecheck do
    url "https://www.openfst.org/twiki/bin/view/FST/FstDownload"
    regex(/href=.*?openfst[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  # Linux bottle removed for GCC 12 migration
  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/openfst"
    rebuild 1
    sha256 cellar: :any, mojave: "7b5808c70f33015aeeab712550521b15041e97254b8cb2a62e1fd00ff45f1cfb"
  end

  fails_with gcc: "5"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-fsts",
                          "--enable-compress",
                          "--enable-grm",
                          "--enable-special"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"text.fst").write <<~EOS
      0 1 a x .5
      0 1 b y 1.5
      1 2 c z 2.5
      2 3.5
    EOS

    (testpath/"isyms.txt").write <<~EOS
      <eps> 0
      a 1
      b 2
      c 3
    EOS

    (testpath/"osyms.txt").write <<~EOS
      <eps> 0
      x 1
      y 2
      z 3
    EOS

    system bin/"fstcompile", "--isymbols=isyms.txt", "--osymbols=osyms.txt", "text.fst", "binary.fst"
    assert_predicate testpath/"binary.fst", :exist?
  end
end
