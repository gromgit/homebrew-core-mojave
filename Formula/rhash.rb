class Rhash < Formula
  desc "Utility for computing and verifying hash sums of files"
  homepage "https://sourceforge.net/projects/rhash/"
  url "https://downloads.sourceforge.net/project/rhash/rhash/1.4.3/rhash-1.4.3-src.tar.gz"
  sha256 "1e40fa66966306920f043866cbe8612f4b939b033ba5e2708c3f41be257c8a3e"
  license "0BSD"
  head "https://github.com/rhash/RHash.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rhash"
    sha256 mojave: "94dcacaf27db0630018d8cb2415c8fc88b633e429960eaa8d1066e6d18078ac0"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-gettext"
    system "make"
    system "make", "install"
    lib.install "librhash/#{shared_library("librhash")}"
    system "make", "-C", "librhash", "install-lib-headers"
  end

  test do
    (testpath/"test").write("test")
    (testpath/"test.sha1").write("a94a8fe5ccb19ba61c4c0873d391e987982fbbd3 test")
    system "#{bin}/rhash", "-c", "test.sha1"
  end
end
