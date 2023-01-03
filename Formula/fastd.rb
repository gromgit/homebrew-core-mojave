class Fastd < Formula
  desc "Fast and Secure Tunnelling Daemon"
  homepage "https://github.com/NeoRaider/fastd"
  url "https://github.com/NeoRaider/fastd.git",
      tag:      "v22",
      revision: "0f47d83eac2047d33efdab6eeaa9f81f17e3ebd1"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/NeoRaider/fastd.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fastd"
    sha256 cellar: :any, mojave: "2fe74d4d31f8f7835265acf9f23ebd477087c651d47cfb3630196cb6245519ab"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libsodium"
  depends_on "libuecc"
  depends_on "openssl@3"

  on_linux do
    depends_on "libcap"
    depends_on "libmnl"
  end

  # remove in next release
  patch do
    url "https://github.com/NeoRaider/fastd/commit/89abc48e60e182f8d57e924df16acf33c6670a9b.patch?full_index=1"
    sha256 "7bcac7dc288961a34830ef0552e1f9985f1b818aa37978b281f542a26fb059b9"
  end

  def install
    mkdir "build" do
      system "meson", "-Db_lto=true", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    system "#{bin}/fastd", "--generate-key"
  end
end
