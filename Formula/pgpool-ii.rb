class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-4.2.5.tar.gz"
  sha256 "d745cf38659596cfd1bc2167012bcb091f87588477bb89803cdbac88e26e0e7d"

  livecheck do
    url "https://www.pgpool.net/mediawiki/index.php/Downloads"
    regex(/href=.*?pgpool-II[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "2596afdc5a5a6c3a1026317df1d655aad1e7f3b31d55106bf3fa58f50dc35ffa"
    sha256 arm64_big_sur:  "5828372d6ca3200174cff7f8ffdd248de570f0d378c60db47ecd35c4a46ecab5"
    sha256 monterey:       "ed50605af924aacd0dc69cc2e82515a7eb0b339c0fd3a4265a0530a6ab3a7cf1"
    sha256 big_sur:        "59740c49588ae2a35b2b15d9f88a7654435d70c05ccf14792054eb9bdd1a2b56"
    sha256 catalina:       "cce39ff3a542fe53fcb46a1a224f65a1b7f791d3a3ba0d85e452cbccba56931b"
    sha256 mojave:         "907f52bf7604e8dc88866f65d12814bf33cd853ebdb4a6d013921e3e499f9ecf"
    sha256 x86_64_linux:   "27cff1b485ad2f62e617b8bf14647f3ea2b43447911a91aa0d97b80668a6a5c1"
  end

  depends_on "postgresql"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    cp etc/"pgpool.conf.sample", testpath/"pgpool.conf"
    system bin/"pg_md5", "--md5auth", "pool_passwd", "--config-file", "pgpool.conf"
  end
end
