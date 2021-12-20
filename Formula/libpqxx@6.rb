class LibpqxxAT6 < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/6.4.7.tar.gz"
  sha256 "3fe9f38df1f0f9b72c8fe1b4bc0185cf14b4ed801a9c783189b735404361ce7f"
  license "BSD-3-Clause"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libpqxx@6"
    rebuild 1
    sha256 cellar: :any, mojave: "4b43e01c10ab5d52e86a773c46a96db433c09fa1f7d246e1e3dad029b060125a"
  end

  keg_only :versioned_formula

  deprecate! date: "2020-06-23", because: :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "xmlto" => :build
  depends_on "libpq"

  def install
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin"
    ENV["PG_CONFIG"] = Formula["libpq"].opt_bin/"pg_config"

    system "./configure", "--prefix=#{prefix}", "--enable-shared"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <pqxx/pqxx>
      int main(int argc, char** argv) {
        pqxx::connection con;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lpqxx",
           "-I#{include}", "-o", "test"
    # Running ./test will fail because there is no running postgresql server
    # system "./test"
  end
end
