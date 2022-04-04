class Libcapn < Formula
  desc "C library to send push notifications to Apple devices"
  homepage "https://web.archive.org/web/20181220090839/libcapn.org/"
  license "MIT"
  revision 1
  head "https://github.com/adobkin/libcapn.git", branch: "master"

  stable do
    url "https://github.com/adobkin/libcapn/archive/v2.0.0.tar.gz"
    sha256 "6a0d786a431864178f19300aa5e1208c6c0cbd2d54fadcd27f032b4f3dd3539e"

    resource "jansson" do
      url "https://github.com/akheron/jansson.git",
          revision: "8f067962f6442bda65f0a8909f589f2616a42c5a"
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libcapn"
    rebuild 1
    sha256 mojave: "9617aab9cb4a0ff73ba81b5701b827639f24b3206d9e22b035df12b1f1d85f87"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  # Compatibility with OpenSSL 1.1
  # Original: https://github.com/adobkin/libcapn/pull/46.diff?full_index=1
  patch do
    url "https://github.com/adobkin/libcapn/commit/d5e7cd219b7a82156de74d04bc3668a07ec96629.patch?full_index=1"
    sha256 "d027dc78f490c749eb04c36001d28ce6296c2716325f48db291ce8e62d56ff26"
  end
  patch do
    url "https://github.com/adobkin/libcapn/commit/5fde3a8faa6ce0da0bfe67834bec684a9c6fc992.patch?full_index=1"
    sha256 "caa70babdc4e028d398e844df461f97b0dc192d5c6cc5569f88319b4fcac5ff7"
  end

  def install
    # head gets jansson as a git submodule
    (buildpath/"src/third_party/jansson").install resource("jansson") if build.stable?
    system "cmake", ".", "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}",
                         *std_cmake_args
    system "make", "install"
    pkgshare.install "examples"
  end

  test do
    system ENV.cc, pkgshare/"examples/send_push_message.c",
                   "-o", "send_push_message",
                   "-I#{Formula["openssl@1.1"].opt_include}",
                   "-L#{lib}/capn", "-lcapn"
    output = shell_output("./send_push_message", 255)
    assert_match "unable to use specified PKCS12 file (errno: 9012)", output
  end
end
