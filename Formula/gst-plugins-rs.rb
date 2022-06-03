class GstPluginsRs < Formula
  desc "GStreamer plugins written in Rust"
  homepage "https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs"
  url "https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/archive/0.8.4/gst-plugins-rs-0.8.4.tar.bz2"
  sha256 "c3499bb73d44f93f0d5238a09e121bef96750e8869651e09daaee5777c2e215c"
  license "MIT"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gst-plugins-rs"
    sha256 cellar: :any, mojave: "8125a9dc7bd74466aac68929cd64164450b1ae352fd55e16d2f0038c129d638d"
  end

  depends_on "cargo-c" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "rust" => :build
  depends_on "dav1d"
  depends_on "gst-plugins-base"
  depends_on "gstreamer"
  depends_on "gtk4"
  depends_on "pango" # for closedcaption

  # commit ref, https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/commit/ea98a0b5964cd196abbb48c621969a8ef33eb157
  # remove in next release
  patch :DATA

  def install
    mkdir "build" do
      # csound is disabled as the dependency detection seems to fail
      # the sodium crate fails while building native code as well
      args = std_meson_args + %w[
        -Dclosedcaption=enabled
        -Ddav1d=enabled
        -Dsodium=disabled
        -Dcsound=disabled
        -Dgtk4=enabled
      ]
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --plugin rsfile")
    assert_match version.to_s, output
  end
end

__END__
diff --git a/video/dav1d/Cargo.toml b/video/dav1d/Cargo.toml
index 9ae00ef..2c2e005 100644
--- a/video/dav1d/Cargo.toml
+++ b/video/dav1d/Cargo.toml
@@ -10,7 +10,7 @@ description = "Dav1d Plugin"

 [dependencies]
 atomic_refcell = "0.1"
-dav1d = "0.7"
+dav1d = "0.8"
 gst = { package = "gstreamer", git = "https://gitlab.freedesktop.org/gstreamer/gstreamer-rs", branch = "0.18", version = "0.18" }
 gst-base = { package = "gstreamer-base", git = "https://gitlab.freedesktop.org/gstreamer/gstreamer-rs", branch = "0.18", version = "0.18" }
 gst-video = { package = "gstreamer-video", git = "https://gitlab.freedesktop.org/gstreamer/gstreamer-rs", branch = "0.18", version = "0.18", features = ["v1_12"] }
