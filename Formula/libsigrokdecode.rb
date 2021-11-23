class Libsigrokdecode < Formula
  desc "Drivers for logic analyzers and other supported devices"
  homepage "https://sigrok.org/"
  license "GPL-3.0-or-later"

  head "git://sigrok.org/libsigrokdecode", branch: "master"

  stable do
    url "git://sigrok.org/libsigrokdecode",
        tag:      "libsigrokdecode-0.5.3",
        revision: "97991a3919da6a07c4c87308ae66fb441bd512e3"
  end

  livecheck do
    url :stable
    regex(/^libsigrokdecode-(\d+(?:\.\d+)+)$/i)
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "glib"
  depends_on "python@3.9"

  def install
    py_version = Formula["python@3.9"].version.major_minor

    inreplace "configure.ac" do |s|
      # Force the build system to pick up the right Python 3
      # library. It'll normally scan for a Python library using a list
      # of major.minor versions which means that it might pick up a
      # version that is different from the one specified in the
      # formula.
      s.sub!(/^(SR_PKG_CHECK\(\[python3\], \[SRD_PKGLIBS\],)\n.*$/, "\\1 [python-#{py_version}-embed])")
    end

    system "./autogen.sh"
    mkdir "build" do
      system "../configure", *std_configure_args, "PYTHON3=python#{py_version}"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libsigrokdecode/libsigrokdecode.h>

      int main() {
        if (srd_init(NULL) != SRD_OK) {
           exit(EXIT_FAILURE);
        }
        if (srd_exit() != SRD_OK) {
           exit(EXIT_FAILURE);
        }
        return 0;
      }
    EOS
    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libsigrokdecode").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
