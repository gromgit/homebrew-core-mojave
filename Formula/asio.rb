class Asio < Formula
  desc "Cross-platform C++ Library for asynchronous programming"
  homepage "https://think-async.com/Asio"
  url "https://downloads.sourceforge.net/project/asio/asio/1.22.1%20%28Stable%29/asio-1.22.1.tar.bz2"
  sha256 "6874d81a863d800ee53456b1cafcdd1abf38bbbf54ecf295056b053c0d7115ce"
  license "BSL-1.0"
  head "https://github.com/chriskohlhoff/asio.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?Stable.*?/asio[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/asio"
    sha256 cellar: :any, mojave: "3e442cddf324bacd5c8c5667b7d1eb95f258b1badf679a961abf155304cfcb23"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openssl@1.1"

  # Tarball is missing `src/examples/cpp20`, which causes error:
  # config.status: error: cannot find input file: `src/examples/cpp20/Makefile.in'
  # TODO: Remove in the next release
  patch :DATA

  def install
    ENV.cxx11

    if build.head?
      cd "asio"
      system "./autogen.sh"
    else
      system "autoconf"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-boost=no"
    system "make", "install"
    pkgshare.install "src/examples"
  end

  test do
    found = Dir[pkgshare/"examples/cpp{11,03}/http/server/http_server"]
    raise "no http_server example file found" if found.empty?

    port = free_port
    pid = fork do
      exec found.first, "127.0.0.1", port.to_s, "."
    end
    sleep 1
    begin
      assert_match "404 Not Found", shell_output("curl http://127.0.0.1:#{port}")
    ensure
      Process.kill 9, pid
    end
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index 56365c2..84045ba 100644
--- a/configure.ac
+++ b/configure.ac
@@ -241,4 +241,4 @@ AC_OUTPUT([
   src/examples/cpp11/Makefile
   src/examples/cpp14/Makefile
   src/examples/cpp17/Makefile
-  src/examples/cpp20/Makefile])
+])
