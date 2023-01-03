class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  url "https://github.com/emqx/emqx/archive/refs/tags/v5.0.12.tar.gz"
  sha256 "dde5c374f6701e46e26e5835bcc0a74ba312d8a349ad89d2e48498cbaa83ce1b"
  license "Apache-2.0"
  head "https://github.com/emqx/emqx.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/emqx"
    sha256 cellar: :any, mojave: "124f43bfaca0d36f8e21ff64f8bb38fec3ac14bfb8163d5c84ee414f26990c5c"
  end

  depends_on "autoconf"  => :build
  depends_on "automake"  => :build
  depends_on "cmake"     => :build
  depends_on "coreutils" => :build
  # emqx cannot be built with Erlang/OTP 25 as of v5.0.11,
  # but the support is in the works and is coming soon
  depends_on "erlang@24" => :build
  depends_on "freetds"   => :build
  depends_on "libtool"   => :build
  depends_on "openssl@3"

  uses_from_macos "curl"    => :build
  uses_from_macos "unzip"   => :build
  uses_from_macos "zip"     => :build

  on_linux do
    depends_on "ncurses"
    depends_on "zlib"
  end

  def install
    ENV["PKG_VSN"] = version.to_s
    touch(".prepare")
    system "make", "emqx-rel"
    prefix.install Dir["_build/emqx/rel/emqx/*"]
    rm %W[
      #{bin}/emqx.cmd
      #{bin}/emqx_ctl.cmd
      #{bin}/no_dot_erlang.boot
    ]
  end

  test do
    exec "ln", "-s", testpath, "data"
    exec bin/"emqx", "start"
    system bin/"emqx_ctl", "status"
    system bin/"emqx", "stop"
  end
end
