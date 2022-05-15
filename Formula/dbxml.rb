class Dbxml < Formula
  desc "Embeddable XML database with XQuery support and other advanced features"
  homepage "https://www.oracle.com/database/technologies/related/berkeleydb.html"
  url "https://download.oracle.com/berkeley-db/dbxml-6.1.4.tar.gz"
  sha256 "a8fc8f5e0c3b6e42741fa4dfc3b878c982ff8f5e5f14843f6a7e20d22e64251a"
  license "AGPL-3.0-only"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "04519c8d0b802cc58234228fb4e697d0e4e83a89304d449f6976c9c5fa8287c5"
    sha256                               arm64_big_sur:  "04e8d59d289cdfeded395a021516b357e5bb63eed09e49aca28ed262c8c31128"
    sha256 cellar: :any,                 monterey:       "33d915b0652f7509895b421e65f6228915f1fddb42820076cb618b711432a898"
    sha256                               big_sur:        "e53e40e0184768fdac585276000c0224a04cfa9284ce94be1ab80380d2b79965"
    sha256                               catalina:       "59c12069d26a6be4f542d4c7869841c2bd71e8cb08a1c809d559818fb1cb156a"
    sha256                               mojave:         "b525b9d21d149d533aeb62a169becfe1e140f143d34291d0a8fddf2ada41a018"
    sha256                               high_sierra:    "1886b654f152fc03a6a6e781ca94e5ca3a08f7f190bc1168326bf46b337c02e9"
    sha256                               sierra:         "2a350300c31d639d46e9fafc16747d5cbe1897035acf1c365f795127535693b3"
    sha256                               el_capitan:     "e2c82383d79f243654a0bbebdfb141334bbf683c6925b5a8f3ce0d1568024fec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb0abe86852f38edf93fe495c3d2644f63bdfd1ebe51eee71f75c8c6d977eb1e"
  end

  depends_on "berkeley-db"
  depends_on "xerces-c"
  depends_on "xqilla"

  uses_from_macos "zlib"

  # No public bug tracker or mailing list to submit this to, unfortunately.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/4d337833ef2e10c1f06a72170f22b1cafe2b6a78/dbxml/c%2B%2B11.patch"
    sha256 "98d518934072d86c15780f10ceee493ca34bba5bc788fd9db1981a78234b0dc4"
  end

  def install
    ENV.cxx11

    inreplace "dbxml/configure" do |s|
      s.gsub! %r{=`ls ("\$with_berkeleydb"/lib)/libdb-\*\.la \| sed -e 's/\.\*db-\\\(\.\*\\\)\.la/},
              "=`find \\1 -name #{shared_library("libdb-*")} -maxdepth 1 ! -type l " \
              "| sed -e 's/#{shared_library(".*db-\\(.*\\)")}/"
      s.gsub! "lib/libdb-*.la", "lib/#{shared_library("libdb-*")}"
      s.gsub! "libz.a", shared_library("libz")
    end

    args = %W[
      --with-xqilla=#{Formula["xqilla"].opt_prefix}
      --with-xerces=#{Formula["xerces-c"].opt_prefix}
      --with-berkeleydb=#{Formula["berkeley-db"].opt_prefix}
    ]
    args << "--with-zlib=#{Formula["zlib"].opt_prefix}" unless OS.mac?

    cd "dbxml" do
      system "./configure", *std_configure_args, *args
      system "make", "install"
    end
  end

  test do
    (testpath/"simple.xml").write <<~EOS
      <breakfast_menu>
        <food>
          <name>Belgian Waffles</name>
          <calories>650</calories>
        </food>
        <food>
          <name>Homestyle Breakfast</name>
          <calories>950</calories>
        </food>
      </breakfast_menu>
    EOS

    (testpath/"dbxml.script").write <<~EOS
      createContainer ""
      putDocument simple "simple.xml" f
      cquery 'sum(//food/calories)'
      print
      quit
    EOS
    assert_equal "1600", shell_output("#{bin}/dbxml -s #{testpath}/dbxml.script").chomp
  end
end
