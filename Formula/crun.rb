class Crun < Formula
  desc "Fast and lightweight fully featured OCI runtime and C library"
  homepage "https://github.com/containers/crun"
  url "https://github.com/containers/crun/releases/download/1.4.2/crun-1.4.2.tar.xz"
  sha256 "636afa526b43732909e9d9cca6597f8cd1b53a65a324179632607dd3d0008eae"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fa2e05eb6b028e79e41b99e07e6c521d0f451f7127184c0e97b5e53a43e70afe"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "go-md2man" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build

  depends_on "libcap"
  depends_on "libseccomp"
  depends_on :linux
  depends_on "systemd"
  depends_on "yajl"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "", shell_output("crun --rootless=true list -q").strip
  end
end
