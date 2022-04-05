class Libhttpserver < Formula
  desc "C++ library of embedded Rest HTTP server"
  homepage "https://github.com/etr/libhttpserver"
  url "https://github.com/etr/libhttpserver/archive/0.18.2.tar.gz"
  sha256 "1dfe548ac2add77fcb6c05bd00222c55650ffd02b209f4e3f133a6e3eb29c89d"
  license "LGPL-2.1-or-later"
  head "https://github.com/etr/libhttpserver.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libhttpserver"
    rebuild 1
    sha256 cellar: :any, mojave: "2c5d8aa2f2694916dff7dff214a49f8ea60bb171657ffaa986047a63cbeb4ea2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libmicrohttpd"

  uses_from_macos "curl" => :test

  def install
    args = [
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
    ]

    system "./bootstrap"
    mkdir "build" do
      system "../configure", *args
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    port = free_port

    cp pkgshare/"examples/minimal_hello_world.cpp", testpath
    inreplace "minimal_hello_world.cpp", "create_webserver(8080)",
                                         "create_webserver(#{port})"

    system ENV.cxx, "minimal_hello_world.cpp",
      "-std=c++11", "-o", "minimal_hello_world", "-L#{lib}", "-lhttpserver", "-lcurl"

    fork { exec "./minimal_hello_world" }
    sleep 3 # grace time for server start

    assert_match "Hello, World!", shell_output("curl http://127.0.0.1:#{port}/hello")
  end
end
