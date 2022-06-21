class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "http://links.twibright.com/"
  url "http://links.twibright.com/download/links-2.27.tar.bz2"
  sha256 "d8ddcbfcede7cdde80abeb0a236358f57fa6beb2bcf92e109624e9b896f9ebb4"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://links.twibright.com/download.php"
    regex(/Current version is v?(\d+(?:\.\d+)+)\. /i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/links"
    rebuild 1
    sha256 cellar: :any, mojave: "27f9a4b7f2ef11d4cc7adeba35f5b0e33144abbea3b3568e15439b70e6e8aeb4"
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "openssl@1.1"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
      --without-lzma
    ]

    system "./configure", *args
    system "make", "install"
    doc.install Dir["doc/*"]
  end

  test do
    system bin/"links", "-dump", "https://duckduckgo.com"
  end
end
