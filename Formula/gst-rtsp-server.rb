class GstRtspServer < Formula
  desc "RTSP server library based on GStreamer"
  homepage "https://gstreamer.freedesktop.org/modules/gst-rtsp-server.html"
  url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/gst-rtsp-server-1.20.3.tar.xz"
  sha256 "ee402718be9b127f0e5e66ca4c1b4f42e4926ec93ba307b7ccca5dc6cc9794ca"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/"
    regex(/href=.*?gst-rtsp-server[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gst-rtsp-server"
    sha256 cellar: :any, mojave: "7f98073089d4c69100e7f00d3b40e345e25f52c003e3c0ecd6d15ec6e21b36fb"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "gstreamer"

  def install
    args = std_meson_args + %w[
      -Dintrospection=enabled
      -Dexamples=disabled
      -Dtests=disabled
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --gst-plugin-path #{lib} --plugin rtspclientsink")
    assert_match(/\s#{version}\s/, output)
  end
end
