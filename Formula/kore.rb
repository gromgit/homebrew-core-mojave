class Kore < Formula
  desc "Web application framework for writing web APIs in C"
  homepage "https://kore.io/"
  url "https://kore.io/releases/kore-4.1.0.tar.gz"
  sha256 "b7d73b005fde0ea01c356a54e4bbd8a209a4dff9cf315802a127ce7267efbe61"
  license "ISC"
  head "https://github.com/jorisvink/kore.git"

  livecheck do
    url "https://kore.io/source"
    regex(/href=.*?kore[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "0903cb7198c7cee03d727ca1dff69ae17c143761702857c5d0925822067ceb9d"
    sha256 arm64_big_sur:  "27b9278bca42a66ef991c721a6e9d4910c72eb5fd4fec1530cebb20444f65d6a"
    sha256 monterey:       "9f6fb2a90b05326a0ee669a32f38487b9526e43bba7722efcc6feee1f9a8b56c"
    sha256 big_sur:        "b9ee5f484ac7eb75b1282afee33da589de37ce1787b15eea441e63526996e47c"
    sha256 catalina:       "1c361e384d9d76c042624f56a0e847f12e9db63a5e0fd49016827bcbdb71eb95"
    sha256 mojave:         "111923e46a1a868241cea5eeed3477ef6de321684308168c8ffac582620ba95a"
    sha256 x86_64_linux:   "915a0b5f6e3598f50e4e457c96221b07006490f5169c666dc745d8ee0c68bced"
  end

  depends_on macos: :sierra # needs clock_gettime

  depends_on "openssl@1.1"

  def install
    # Ensure make finds our OpenSSL when Homebrew isn't in /usr/local.
    # Current Makefile hardcodes paths for default MacPorts/Homebrew.
    ENV.prepend "CFLAGS", "-I#{Formula["openssl@1.1"].opt_include}"
    ENV.prepend "LDFLAGS", "-L#{Formula["openssl@1.1"].opt_lib}"
    # Also hardcoded paths in src/cli.c at compile.
    inreplace "src/cli.c", "/usr/local/opt/openssl/include",
                            Formula["openssl@1.1"].opt_include

    ENV.deparallelize { system "make", "PREFIX=#{prefix}", "TASKS=1" }
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"kodev", "create", "test"
    cd "test" do
      system bin/"kodev", "build"
      system bin/"kodev", "clean"
    end
  end
end
