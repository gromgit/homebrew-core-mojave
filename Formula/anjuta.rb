class Anjuta < Formula
  desc "GNOME Integrated Development Environment"
  homepage "http://anjuta.org"
  url "https://download.gnome.org/sources/anjuta/3.34/anjuta-3.34.0.tar.xz"
  sha256 "42a93130ed3ee02d064a7094e94e1ffae2032b3f35a87bf441e37fc3bb3a148f"
  revision 4

  bottle do
    sha256 arm64_big_sur: "185ac50d99816b00213f7e3a6430c06dcef89408d92b0b8285772789ed600dde"
    sha256 big_sur:       "cb89537f1f0f79d74b348604fdf02a0d8c7e48a8b9211aade1a18e2d4eb1d70b"
    sha256 catalina:      "2b2f88450c12c599e2c730bafabd678006b75ab74eee017743ba9a34338e1f3c"
    sha256 mojave:        "1c63382333afdfbcb3cc0c9b2c75f2dff445bbdc749464252067ab707dab7e85"
  end

  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "autogen"
  depends_on "gdl"
  depends_on "gnome-themes-standard"
  depends_on "gnutls"
  depends_on "gtksourceview3"
  depends_on "hicolor-icon-theme"
  depends_on "libgda"
  depends_on "libxml2"
  depends_on "python@3.9"
  depends_on "shared-mime-info"
  depends_on "vala"
  depends_on "vte3"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile"

    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python#{xy}/site-packages"
    system "make", "install"
  end

  def post_install
    hshare = HOMEBREW_PREFIX/"share"

    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", hshare/"glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", hshare/"icons/hicolor"
    # HighContrast is provided by gnome-themes-standard
    if File.file?("#{hshare}/icons/HighContrast/.icon-theme.cache")
      system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", hshare/"icons/HighContrast"
    end
    system "#{Formula["shared-mime-info"].opt_bin}/update-mime-database", hshare/"mime"
  end

  test do
    system "#{bin}/anjuta", "--version"
  end
end
