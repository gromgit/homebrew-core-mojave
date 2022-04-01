class Libxml2 < Formula
  desc "GNOME XML library"
  homepage "http://xmlsoft.org/"
  license "MIT"

  stable do
    url "https://download.gnome.org/sources/libxml2/2.9/libxml2-2.9.13.tar.xz"
    sha256 "276130602d12fe484ecc03447ee5e759d0465558fbc9d6bd144e3745306ebf0e"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  # We use a common regex because libxml2 doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libxml2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libxml2"
    sha256 cellar: :any, mojave: "18ec53450588c519b20b7714d3fca564b0db28e523fa6a094806c1afe1bd5f41"
  end

  head do
    url "https://gitlab.gnome.org/GNOME/libxml2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
  end

  keg_only :provided_by_macos

  depends_on "python@3.9" => [:build, :test]
  depends_on "readline"

  uses_from_macos "zlib"

  # Fix crash when using Python 3 using Fedora's patch.
  # Reported upstream:
  # https://bugzilla.gnome.org/show_bug.cgi?id=789714
  # https://gitlab.gnome.org/GNOME/libxml2/issues/12
  patch do
    url "https://bugzilla.opensuse.org/attachment.cgi?id=746044"
    sha256 "37eb81a8ec6929eed1514e891bff2dd05b450bcf0c712153880c485b7366c17c"
  end

  def sdk_include
    on_macos do
      return MacOS.sdk_path/"usr/include"
    end
    on_linux do
      return HOMEBREW_PREFIX/"include"
    end
  end

  def install
    system "autoreconf", "-fiv" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-history",
                          "--without-python",
                          "--without-lzma"
    system "make", "install"

    cd "python" do
      # We need to insert our include dir first
      inreplace "setup.py", "includes_dir = [",
                            "includes_dir = ['#{include}', '#{sdk_include}',"
      system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libxml/tree.h>

      int main()
      {
        xmlDocPtr doc = xmlNewDoc(BAD_CAST "1.0");
        xmlNodePtr root_node = xmlNewNode(NULL, BAD_CAST "root");
        xmlDocSetRootElement(doc, root_node);
        xmlFreeDoc(doc);
        return 0;
      }
    EOS
    args = %w[test.c -o test]
    args += shell_output("#{bin}/xml2-config --cflags --libs").split
    system ENV.cc, *args
    system "./test"

    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_path "PYTHONPATH", lib/"python#{xy}/site-packages"
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import libxml2"
  end
end
