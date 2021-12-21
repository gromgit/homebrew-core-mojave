class Libvoikko < Formula
  desc "Linguistic software and Finnish dictionary"
  homepage "https://voikko.puimula.org/"
  url "https://www.puimula.org/voikko-sources/libvoikko/libvoikko-4.3.1.tar.gz"
  sha256 "368240d4cfa472c2e2c43dc04b63e6464a3e6d282045848f420d0f7a6eb09a13"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.puimula.org/voikko-sources/libvoikko/"
    regex(/href=.*?libvoikko[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libvoikko"
    rebuild 1
    sha256 cellar: :any, mojave: "72a66585fd710df9b980793e88068e183026f72fbed8fa308c4b5a9c37330142"
  end

  depends_on "foma" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "hfstospell"

  resource "voikko-fi" do
    url "https://www.puimula.org/voikko-sources/voikko-fi/voikko-fi-2.4.tar.gz"
    sha256 "320b2d4e428f6beba9d0ab0d775f8fbe150284fbbafaf3e5afaf02524cee28cc"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-dictionary-path=#{HOMEBREW_PREFIX}/lib/voikko"
    system "make", "install"

    resource("voikko-fi").stage do
      ENV.append_path "PATH", bin.to_s
      system "make", "vvfst"
      system "make", "vvfst-install", "DESTDIR=#{lib}/voikko"
      lib.install_symlink "voikko"
    end
  end

  test do
    assert_match "C: onkohan", pipe_output("#{bin}/voikkospell -m", "onkohan\n")
  end
end
