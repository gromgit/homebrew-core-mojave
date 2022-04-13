class Librist < Formula
  desc "Reliable Internet Stream Transport (RIST)"
  homepage "https://code.videolan.org/rist/"
  url "https://code.videolan.org/rist/librist/-/archive/v0.2.7/librist-v0.2.7.tar.gz"
  sha256 "7e2507fdef7b57c87b461d0f2515771b70699a02c8675b51785a73400b3c53a1"
  license "BSD-2-Clause"
  head "https://code.videolan.org/rist/librist.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/librist"
    sha256 cellar: :any, mojave: "2b0f1b13551ee23849c405bd5b27108c45117aef1cd509e4b3f8ece20e7cfdb9"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cjson"
  depends_on "cmocka"
  depends_on "mbedtls"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    system "meson", *std_meson_args, "build", ".", "--default-library", "both"
    system "ninja", "install", "-C", "build"
  end

  test do
    assert_match "Starting ristsender", shell_output("#{bin}/ristsender 2>&1", 1)
  end
end
