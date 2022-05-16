class GstPluginsRs < Formula
  desc "GStreamer plugins written in Rust"
  homepage "https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs"
  url "https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/archive/0.8.4/gst-plugins-rs-0.8.4.tar.bz2"
  sha256 "c3499bb73d44f93f0d5238a09e121bef96750e8869651e09daaee5777c2e215c"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gst-plugins-rs"
    sha256 cellar: :any, mojave: "b730d29254da8c6cb88c509d278384aa788102043fa312c21821fc1632f72067"
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
