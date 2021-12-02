class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v3.22.0/qalculate-gtk-3.22.0.tar.gz"
  sha256 "ba6c0238b5f926ac94e234e15a2dfa84215938da5df6fea136db75c5db488556"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/qalculate-gtk"
    rebuild 1
    sha256 mojave: "e52b5271909e75061c67757fcaddf0d31a6b0fb0553408402dc81fcc510d4721"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "libqalculate"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/qalculate-gtk", "-v"
  end
end
