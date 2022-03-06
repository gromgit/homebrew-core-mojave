class Groonga < Formula
  desc "Fulltext search engine and column store"
  homepage "https://groonga.org/"
  url "https://packages.groonga.org/source/groonga/groonga-12.0.0.tar.gz"
  sha256 "eb1b1aa69d6e8c2c4ac29e232686302a7f5e492d4e56bc6e206a0e66373b62fa"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(%r{>v?(\d+(?:\.\d+)+)</a> is the latest release}i)
  end

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/groonga"
    rebuild 1
    sha256 mojave: "15a02a540da0b0f9015083b190fd763d7999c4743bd90d495d1ca378c2c5008c"
  end

  head do
    url "https://github.com/groonga/groonga.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "mecab"
  depends_on "mecab-ipadic"
  depends_on "msgpack"
  depends_on "openssl@1.1"
  depends_on "pcre"

  on_linux do
    depends_on "glib"
  end

  link_overwrite "lib/groonga/plugins/normalizers/"
  link_overwrite "share/doc/groonga-normalizer-mysql/"
  link_overwrite "lib/pkgconfig/groonga-normalizer-mysql.pc"

  resource "groonga-normalizer-mysql" do
    url "https://packages.groonga.org/source/groonga-normalizer-mysql/groonga-normalizer-mysql-1.1.8.tar.gz"
    sha256 "0ed23e0c0b4d4dca23c57bbd98fe3d051c3f3ddacbbe55d07fddb6c53142cae5"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-zeromq
      --disable-apache-arrow
      --enable-mruby
      --with-luajit=no
      --with-ssl
      --with-zlib
      --without-libstemmer
      --with-mecab
    ]

    if build.head?
      args << "--with-ruby"
      system "./autogen.sh"
    end

    mkdir "builddir" do
      system "../configure", *args
      system "make", "install"
    end

    resource("groonga-normalizer-mysql").stage do
      ENV.prepend_path "PATH", bin
      ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig"
      system "./configure", "--prefix=#{prefix}"
      system "make"
      system "make", "install"
    end
  end

  test do
    IO.popen("#{bin}/groonga -n #{testpath}/test.db", "r+") do |io|
      io.puts("table_create --name TestTable --flags TABLE_HASH_KEY --key_type ShortText")
      sleep 2
      io.puts("shutdown")
      # expected returned result is like this:
      # [[0,1447502555.38667,0.000824928283691406],true]\n
      assert_match(/\[\[0,\d+.\d+,\d+.\d+\],true\]/, io.read)
    end

    IO.popen("#{bin}/groonga -n #{testpath}/test-normalizer-mysql.db", "r+") do |io|
      io.puts "register normalizers/mysql"
      sleep 2
      io.puts("shutdown")
      # expected returned result is like this:
      # [[0,1447502555.38667,0.000824928283691406],true]\n
      assert_match(/\[\[0,\d+.\d+,\d+.\d+\],true\]/, io.read)
    end
  end
end
