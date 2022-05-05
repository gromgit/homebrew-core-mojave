class Libpinyin < Formula
  desc "Library to deal with pinyin"
  homepage "https://github.com/libpinyin/libpinyin"
  url "https://github.com/libpinyin/libpinyin/archive/2.6.2.tar.gz"
  sha256 "73f428a1c76a44a9ff666ae3c71b9ce4d96d07bc5b5af8081a85ef66a0383777"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libpinyin"
    sha256 cellar: :any, mojave: "5ba9c70f0ca8d13d43a54a420b9878f8e8015a60432ee3f92f8a6277e9a1332e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gnome-common" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db"
  depends_on "glib"

  # The language model file is independently maintained by the project owner.
  # To update this resource block, the URL can be found in data/Makefile.am.
  resource "model" do
    url "https://downloads.sourceforge.net/libpinyin/models/model19.text.tar.gz"
    sha256 "56422a4ee5966c2c809dd065692590ee8def934e52edbbe249b8488daaa1f50b"
  end

  def install
    resource("model").stage buildpath/"data"
    system "./autogen.sh", "--enable-libzhuyin=yes",
                           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <pinyin.h>

      int main()
      {
          pinyin_context_t * context = pinyin_init (LIBPINYIN_DATADIR, "");

          if (context == NULL)
              return 1;

          pinyin_instance_t * instance = pinyin_alloc_instance (context);

          if (instance == NULL)
              return 1;

          pinyin_free_instance (instance);

          pinyin_fini (context);

          return 0;
      }
    EOS
    glib = Formula["glib"]
    flags = %W[
      -I#{include}/libpinyin-#{version}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -L#{lib}
      -L#{glib.opt_lib}
      -DLIBPINYIN_DATADIR="#{lib}/libpinyin/data/"
      -lglib-2.0
      -lpinyin
    ]
    system ENV.cxx, "test.cc", "-o", "test", *flags
    touch "user.conf"
    system "./test"
  end
end
