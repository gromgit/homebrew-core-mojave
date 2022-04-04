class LibbitcoinDatabase < Formula
  desc "Bitcoin High Performance Blockchain Database"
  homepage "https://github.com/libbitcoin/libbitcoin-database"
  url "https://github.com/libbitcoin/libbitcoin-database/archive/v3.6.0.tar.gz"
  sha256 "d65b35745091b93feed61c5665b5a07b404b578e2582640e93c1a01f6b746f5a"
  license "AGPL-3.0"
  revision 2

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libbitcoin-database"
    rebuild 1
    sha256 cellar: :any, mojave: "d9ac642cef50514268ed810027c009e262f0480adef7cf0a427f5f3f9bf89fe6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  # https://github.com/libbitcoin/libbitcoin-system/issues/1234
  depends_on "boost@1.76"
  depends_on "libbitcoin"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libbitcoin"].opt_libexec/"lib/pkgconfig"

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-boost-libdir=#{Formula["boost@1.76"].opt_lib}"
    system "make", "install"
  end

  test do
    boost = Formula["boost@1.76"]
    (testpath/"test.cpp").write <<~EOS
      #include <bitcoin/database.hpp>
      using namespace libbitcoin::database;
      using namespace libbitcoin::chain;
      int main() {
        static const transaction tx{ 0, 0, input::list{}, output::list{ output{} } };
        unspent_outputs cache(42);
        cache.add(tx, 0, 0, false);
        assert(cache.size() == 1u);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test",
                    "-I#{boost.include}",
                    "-L#{Formula["libbitcoin"].opt_lib}", "-lbitcoin",
                    "-L#{lib}", "-lbitcoin-database",
                    "-L#{boost.lib}", "-lboost_system"
    system "./test"
  end
end
