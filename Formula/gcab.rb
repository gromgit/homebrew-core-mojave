class Gcab < Formula
  desc "Windows installer (.MSI) tool"
  homepage "https://wiki.gnome.org/msitools"
  url "https://download.gnome.org/sources/gcab/1.5/gcab-1.5.tar.xz"
  sha256 "46bf7442491faa4148242b9ec2a0786a5f6e9effb1b0566e5290e8cc86f00f0c"
  license "LGPL-2.1-or-later"

  # We use a common regex because gcab doesn't use GNOME's "even-numbered minor
  # is stable" version scheme.
  livecheck do
    url :stable
    regex(/gcab[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gcab"
    sha256 mojave: "42bbc262b3ec6a42d94a5fbf756151d469f5728855d64f561c600e68e4171790"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"

  # build patch for git version check, remove in next version
  patch do
    url "https://github.com/GNOME/gcab/commit/ad0baea50359c1978a9224ee60bf98d97bfb991f.patch?full_index=1"
    sha256 "e25a2f6651c7096c553c9e57a086140e666169a6520a55f7d67ccabd1c0190be"
  end

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Ddocs=false", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    system "#{bin}/gcab", "--version"
  end
end
