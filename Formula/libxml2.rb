class Libxml2 < Formula
  desc "GNOME XML library"
  homepage "http://xmlsoft.org/"
  license "MIT"

  stable do
    url "http://xmlsoft.org/sources/libxml2-2.9.12.tar.gz"
    mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/libxml2/libxml2-2.9.12.tar.gz"
    sha256 "c8d6681e38c56f172892c85ddc0852e1fd4b53b4209e7f4ebf17f7e2eae71d92"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url "http://xmlsoft.org/sources/"
    regex(/href=.*?libxml2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b279b3fe83d85482b13607b051188b256ee9382ffec26230d42fdbb1f96642ae"
    sha256 cellar: :any,                 arm64_big_sur:  "a08e1ca1be7f5d1b1cf4eee4efabf906fb59fec8422292fe124002aa98d11540"
    sha256 cellar: :any,                 monterey:       "f03e58ff77808c951c61fa10465965a9f71e94e1da8b850d70c335a8f3b9fc12"
    sha256 cellar: :any,                 big_sur:        "fbc422ede343b2bd4047ccdf2f697430da636b66fc550697a2f921b97cebe18f"
    sha256 cellar: :any,                 catalina:       "eb2c8a444b4cf1f09e35c23b91e7cc16c11bc63527bfc3e19a4442e41cfd4b4d"
    sha256 cellar: :any,                 mojave:         "cf7b2b2ddb047582b9fb5c649d76ab6d4025ea328dff5ad22bcc4d929a8730ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28c0f1b5ed535d8ac6ae60d8ecde883605ed21691ad89be8869d47427a44b7a2"
  end

  head do
    url "https://gitlab.gnome.org/GNOME/libxml2.git"

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
      system Formula["python@3.9"].opt_bin/"python3", "setup.py", "install", "--prefix=#{prefix}"
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
