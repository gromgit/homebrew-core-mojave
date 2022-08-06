class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "http://links.twibright.com/"
  url "http://links.twibright.com/download/links-2.27.tar.bz2"
  sha256 "d8ddcbfcede7cdde80abeb0a236358f57fa6beb2bcf92e109624e9b896f9ebb4"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "http://links.twibright.com/download.php"
    regex(/Current version is v?(\d+(?:\.\d+)+)\. /i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/links"
    sha256 cellar: :any, mojave: "e4b85e1966820631ee4bb247cd046d02ade656c6a6f4ad8ff10702982a5c5e8e"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args,
                          "--mandir=#{man}",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--without-lzma"
    system "make", "install"
    doc.install Dir["doc/*"]
  end

  test do
    system bin/"links", "-dump", "https://duckduckgo.com"
  end
end
