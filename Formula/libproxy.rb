class Libproxy < Formula
  desc "Library that provides automatic proxy configuration management"
  homepage "https://libproxy.github.io/libproxy/"
  url "https://github.com/libproxy/libproxy/archive/0.4.17.tar.gz"
  sha256 "88c624711412665515e2800a7e564aabb5b3ee781b9820eca9168035b0de60a9"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/libproxy/libproxy.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libproxy"
    rebuild 1
    sha256 mojave: "30092f5eb19e00d357a0557c1ef58c336dc13dbeb86d3aebf986f7e4b4963f4d"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10"

  on_linux do
    depends_on "dbus"
    depends_on "glib"
  end

  def install
    args = std_cmake_args + %W[
      ..
      -DPYTHON3_SITEPKG_DIR=#{prefix/Language::Python.site_packages("python3")}
      -DWITH_PERL=OFF
      -DWITH_PYTHON2=OFF
    ]

    mkdir "build" do
      system "cmake", *args
      system "make", "install"
    end
  end

  test do
    assert_equal "direct://", pipe_output("#{bin}/proxy 127.0.0.1").chomp
  end
end
