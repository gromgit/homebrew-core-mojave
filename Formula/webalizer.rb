class Webalizer < Formula
  desc "Web server log file analysis"
  homepage "https://web.archive.org/web/20200622121953/www.webalizer.org/"
  url "https://web.archive.org/web/20200205152356/ftp.mrunix.net/pub/webalizer/webalizer-2.23-08-src.tgz"
  mirror "https://deb.debian.org/debian/pool/main/w/webalizer/webalizer_2.23.08.orig.tar.gz"
  sha256 "edaddb5aa41cc4a081a1500e3fa96615d4b41bc12086bcedf9938018ce79ed8d"
  license "GPL-2.0-or-later"
  revision 3

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/webalizer"
    sha256 mojave: "7ab82c8c113c9ac3db7fb277e5d1365e84a71c74031a57dfc036898923169438"
  end

  deprecate! date: "2022-05-29", because: :unmaintained

  depends_on "berkeley-db@5"
  depends_on "gd"
  depends_on "libpng"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test.log").write \
      "127.0.0.1 user-identifier homebrew [10/Oct/2000:13:55:36 -0700] \"GET /beer.gif HTTP/1.0\" 200 2326"
    system "#{bin}/webalizer", "-c", etc/"webalizer.conf.sample", testpath/"test.log"
    assert_predicate testpath/"usage.png", :exist?
    assert_predicate testpath/"index.html", :exist?
  end
end
