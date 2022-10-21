class Libagg < Formula
  desc "High fidelity 2D graphics library for C++"
  homepage "https://antigrain.com/"
  # Canonical URL inaccessible: https://antigrain.com/agg-2.5.tar.gz
  url "https://ftp.osuosl.org/pub/blfs/8.0/a/agg-2.5.tar.gz"
  sha256 "ab1edc54cc32ba51a62ff120d501eecd55fceeedf869b9354e7e13812289911f"
  license "GPL-2.0"
  revision 1

  # The homepage for this formula is a copy of the original and was created
  # after the original was discontinued. There will be no further releases of
  # the copy of this software used in the formula, as the developer is deceased.
  # New development of libagg occurs in a fork of v2.4 and can be found at:
  # https://sourceforge.net/projects/agg/
  livecheck do
    skip "No longer developed/maintained"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libagg"
    sha256 cellar: :any, mojave: "427f17f0d369d2a97ea11ccf969c4134d2ae8f8291bf03ec0f5380291fa9f3ef"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl12-compat"

  # Fix build with clang; last release was in 2006
  patch :DATA

  def install
    # AM_C_PROTOTYPES was removed in automake 1.12, as it's only needed for
    # pre-ANSI compilers
    inreplace "configure.in", "AM_C_PROTOTYPES", ""
    inreplace "autogen.sh", "libtoolize", "glibtoolize"

    system "sh", "autogen.sh",
                 "--disable-dependency-tracking",
                 "--prefix=#{prefix}",
                 "--disable-platform", # Causes undefined symbols
                 "--disable-ctrl",     # No need to run these during configuration
                 "--disable-examples",
                 "--disable-sdltest"
    system "make", "install"
  end
end

__END__
diff --git a/include/agg_renderer_outline_aa.h b/include/agg_renderer_outline_aa.h
index ce25a2e..9a12d35 100644
--- a/include/agg_renderer_outline_aa.h
+++ b/include/agg_renderer_outline_aa.h
@@ -1375,7 +1375,7 @@ namespace agg
         //---------------------------------------------------------------------
         void profile(const line_profile_aa& prof) { m_profile = &prof; }
         const line_profile_aa& profile() const { return *m_profile; }
-        line_profile_aa& profile() { return *m_profile; }
+        const line_profile_aa& profile() { return *m_profile; }

         //---------------------------------------------------------------------
         int subpixel_width() const { return m_profile->subpixel_width(); }
