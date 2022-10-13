class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "http://links.twibright.com/"
  url "http://links.twibright.com/download/links-2.28.tar.bz2"
  sha256 "2fd5499b13dee59457c132c167b8495c40deda75389489c6cccb683193f454b4"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://links.twibright.com/download.php"
    regex(/Current version is v?(\d+(?:\.\d+)+)\. /i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/links"
    sha256 cellar: :any, mojave: "52bef814b9e261dd92818f0c877eed4b984fa26608899f8b88b6b7968964147d"
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
