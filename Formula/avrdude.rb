class Avrdude < Formula
  desc "Atmel AVR MCU programmer"
  homepage "https://savannah.nongnu.org/projects/avrdude/"
  license "GPL-2.0-or-later"
  revision 1

  stable do
    url "https://download.savannah.gnu.org/releases/avrdude/avrdude-6.4.tar.gz"
    mirror "https://download-mirror.savannah.gnu.org/releases/avrdude/avrdude-6.4.tar.gz"
    sha256 "a9be7066f70a9dcf4bf0736fcf531db6a3250aed1a24cc643add27641b7110f9"

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
    sha256 mojave: "b17bf1487a0c03df2ed77efffd5098dc542bf69569d57c608a21a12fc7a1c4e9"
  end

  head do
    url "https://svn.savannah.nongnu.org/svn/avrdude/trunk/avrdude"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "automake" => :build
  depends_on "hidapi"
  depends_on "libftdi0"
  depends_on "libhid"
  depends_on "libusb-compat"

  uses_from_macos "bison"
  uses_from_macos "flex"

  on_macos do
    depends_on "libelf"
  end

  on_linux do
    depends_on "elfutils"
  end

  def install
    # Workaround for ancient config files not recognizing aarch64 macos.
    am = Formula["automake"]
    am_share = am.opt_share/"automake-#{am.version.major_minor}"
    %w[config.guess config.sub].each do |fn|
      chmod "u+w", fn
      cp am_share/fn, fn
    end

    if build.head?
      inreplace "bootstrap", /libtoolize/, "glibtoolize"
      system "./bootstrap"
    end
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "avrdude done.  Thank you.",
      shell_output("#{bin}/avrdude -c jtag2 -p x16a4 2>&1", 1).strip
  end
end
