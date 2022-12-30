class Avrdude < Formula
  desc "Atmel AVR MCU programmer"
  homepage "https://www.nongnu.org/avrdude/"
  license "GPL-2.0-or-later"
  revision 2

  stable do
    url "https://download.savannah.gnu.org/releases/avrdude/avrdude-7.0.tar.gz"
    mirror "https://download-mirror.savannah.gnu.org/releases/avrdude/avrdude-7.0.tar.gz"
    sha256 "c0ef65d98d6040ca0b4f2b700d51463c2a1f94665441f39d15d97442dbb79b54"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url "https://download.savannah.gnu.org/releases/avrdude/"
    regex(/href=.*?avrdude[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/avrdude"
    rebuild 1
    sha256 mojave: "c3628b81378cecc0e7f9541d76dbd733d29d9afa33a6b135dc2aafa5c64867a3"
  end

  head do
    url "https://github.com/avrdudes/avrdude.git", branch: "main"
    depends_on "cmake" => :build
  end

  depends_on "hidapi"
  depends_on "libftdi"
  depends_on "libusb"
  depends_on "libusb-compat"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_macos do
    depends_on "libelf" => :build
  end

  on_linux do
    depends_on "elfutils"
    depends_on "readline"
  end

  def install
    if build.head?
      args = std_cmake_args + ["-DCMAKE_INSTALL_SYSCONFDIR=#{etc}"]
      shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
      shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup" if OS.mac?

      system "cmake", "-S", ".", "-B", "build/shared", *args, *shared_args
      system "cmake", "--build", "build/shared"
      system "cmake", "--install", "build/shared"

      system "cmake", "-S", ".", "-B", "build/static", *args
      system "cmake", "--build", "build/static"
      lib.install "build/static/src/libavrdude.a"
    else
      system "./configure", *std_configure_args, "--sysconfdir=#{etc}"
      system "make"
      system "make", "install"
    end
  end

  test do
    output = shell_output("#{bin}/avrdude -c jtag2 -p x16a4 2>&1", 1).strip
    refute_match "avrdude was compiled without usb support", output
    assert_match "avrdude done.  Thank you.", output
  end
end
