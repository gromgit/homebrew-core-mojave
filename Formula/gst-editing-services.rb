class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gst-editing-services-1.20.3.tar.xz"
  sha256 "5fd896de69fbe24421eb6b0ff8d2f8b4c3cba3f3025ceacd302172f39a8abaa2"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-editing-services/"
    regex(/href=.*?gst(?:reamer)?-editing-services[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gst-editing-services"
    sha256 cellar: :any, mojave: "93b494b27b76fab27a866b942354d16ef5e64e2d796d455d392309f74cef3b6d"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gst-plugins-base"
  depends_on "gstreamer"

  uses_from_macos "flex" => :build

  on_linux do
    depends_on "json-glib"
  end

  def install
    args = std_meson_args + %w[
      -Dintrospection=enabled
      -Dtests=disabled
      -Dvalidate=disabled
    ]
    # https://gitlab.freedesktop.org/gstreamer/gst-editing-services/-/issues/114
    # https://github.com/Homebrew/homebrew-core/pull/84906
    args << "-Dpython=disabled"

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system "#{bin}/ges-launch-1.0", "--ges-version"
  end
end
