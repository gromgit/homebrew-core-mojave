class Ettercap < Formula
  desc "Multipurpose sniffer/interceptor/logger for switched LAN"
  homepage "https://ettercap.github.io/ettercap/"
  url "https://github.com/Ettercap/ettercap/archive/v0.8.3.1.tar.gz"
  sha256 "d0c3ef88dfc284b61d3d5b64d946c1160fd04276b448519c1ae4438a9cdffaf3"
  license "GPL-2.0-or-later"
  head "https://github.com/Ettercap/ettercap.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ettercap"
    rebuild 2
    sha256 mojave: "add3dd759c896d3b822088d741eb6f8866ad20cbe374cd1a71d1c2dca104b4a2"
  end

  depends_on "cmake" => :build
  depends_on "geoip"
  depends_on "gtk+3"
  depends_on "libnet"
  depends_on "ncurses" if DevelopmentTools.clang_build_version >= 1000
  depends_on "openssl@1.1"
  depends_on "pcre"

  uses_from_macos "curl"
  uses_from_macos "flex"
  uses_from_macos "libpcap"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    # Work around a CMake bug affecting harfbuzz headers and pango
    # https://gitlab.kitware.com/cmake/cmake/issues/19531
    ENV.append_to_cflags "-I#{Formula["harfbuzz"].opt_include}/harfbuzz"

    # Fix build error on wdg_file.c: fatal error: menu.h: No such file or directory
    ENV.append_to_cflags "-I#{Formula["ncurses"].opt_include}/ncursesw" if OS.linux?

    args = std_cmake_args + %W[
      -DBUNDLED_LIBS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DENABLE_CURSES=ON
      -DENABLE_GTK=ON
      -DENABLE_IPV6=ON
      -DENABLE_LUA=OFF
      -DENABLE_PDF_DOCS=OFF
      -DENABLE_PLUGINS=ON
      -DGTK_BUILD_TYPE=GTK3
      -DGTK3_GLIBCONFIG_INCLUDE_DIR=#{Formula["glib"].opt_lib}/glib-2.0/include
      -DINSTALL_DESKTOP=ON
      -DINSTALL_SYSCONFDIR=#{etc}
    ]
    args << "-DPOLKIT_DIR=#{share}/polkit-1/actions/" if OS.linux?

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ettercap --version")
  end
end
