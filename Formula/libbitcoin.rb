class Libbitcoin < Formula
  desc "Bitcoin Cross-Platform C++ Development Toolkit"
  homepage "https://github.com/libbitcoin/libbitcoin-system"
  url "https://github.com/libbitcoin/libbitcoin-system/archive/v3.6.0.tar.gz"
  sha256 "5bcc4c31b53acbc9c0d151ace95d684909db4bf946f8d724f76c711934c6775c"
  license "AGPL-3.0"
  revision 8

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libbitcoin"
    rebuild 1
    sha256 cellar: :any, mojave: "7eb969c399c443c047ca99573896e775a572b924fd2054b280854a01e196e5cc"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  # https://github.com/libbitcoin/libbitcoin-system/issues/1234
  depends_on "boost@1.76"
  depends_on "libpng"
  depends_on "qrencode"

  resource "secp256k1" do
    url "https://github.com/libbitcoin/secp256k1/archive/v0.1.0.13.tar.gz"
    sha256 "9e48dbc88d0fb5646d40ea12df9375c577f0e77525e49833fb744d3c2a69e727"
  end

  def install
    ENV.cxx11
    resource("secp256k1").stage do
      system "./autogen.sh"
      system "./configure", "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{libexec}",
                            "--enable-module-recovery",
                            "--with-bignum=no"
      system "make", "install"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", "#{libexec}/lib/pkgconfig"

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-boost-libdir=#{Formula["boost@1.76"].opt_lib}",
                          "--with-png",
                          "--with-qrencode"
    system "make", "install"
  end

  test do
    boost = Formula["boost@1.76"]
    (testpath/"test.cpp").write <<~EOS
      #include <bitcoin/bitcoin.hpp>
      int main() {
        const auto block = bc::chain::block::genesis_mainnet();
        const auto& tx = block.transactions().front();
        const auto& input = tx.inputs().front();
        const auto script = input.script().to_data(false);
        std::string message(script.begin() + sizeof(uint64_t), script.end());
        std::cout << message << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp",
                    "-I#{boost.include}",
                    "-L#{lib}", "-lbitcoin",
                    "-L#{boost.lib}", "-lboost_system",
                    "-o", "test"
    system "./test"
  end
end
