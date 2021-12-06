class Libmpdclient < Formula
  desc "Library for MPD in the C, C++, and Objective-C languages"
  homepage "https://www.musicpd.org/libs/libmpdclient/"
  url "https://www.musicpd.org/download/libmpdclient/2/libmpdclient-2.20.tar.xz"
  sha256 "18793f68e939c3301e34d8fcadea1f7daa24143941263cecadb80126194e277d"
  license "BSD-3-Clause"
  head "https://github.com/MusicPlayerDaemon/libmpdclient.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libmpdclient"
    sha256 cellar: :any, mojave: "0adb57e930c67051a281fc1750f545624aa8a452f8806ce7f9a2581c94ff2d47"
  end

  depends_on "doxygen" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", *std_meson_args, ".", "output"
    system "ninja", "-C", "output"
    system "ninja", "-C", "output", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <mpd/client.h>
      int main() {
        mpd_connection_new(NULL, 0, 30000);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lmpdclient", "-o", "test"
    system "./test"
  end
end
