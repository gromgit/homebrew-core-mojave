class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/1.6.3.tar.gz"
  sha256 "1116419527edfe73717b71407fb6e06f46098fc8a8e6b0bb778c4c75dc9f64b9"
  license "MIT"
  revision 6
  head "https://github.com/tsl0922/ttyd.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ttyd"
    sha256 mojave: "4c7266afdc59ab1aff134c58d7ff0ef2ea57d0fa66b708fc53f29f535375314c"
  end

  depends_on "cmake" => :build
  depends_on "json-c"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "libwebsockets"
  depends_on "openssl@1.1"

  uses_from_macos "vim" # needed for xxd

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}",
                    "-Dlibwebsockets_DIR=#{Formula["libwebsockets"].opt_lib/"cmake/libwebsockets"}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    port = free_port
    fork do
      system "#{bin}/ttyd", "--port", port.to_s, "bash"
    end
    sleep 5

    system "curl", "-sI", "http://localhost:#{port}"
  end
end
