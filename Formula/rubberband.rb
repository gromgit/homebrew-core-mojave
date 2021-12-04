class Rubberband < Formula
  desc "Audio time stretcher tool and library"
  homepage "https://breakfastquay.com/rubberband/"
  url "https://breakfastquay.com/files/releases/rubberband-2.0.0.tar.bz2"
  sha256 "eccbf0545496ce3386a2433ceec31e6576a76ed6884310e4b465003bfe260286"
  license "GPL-2.0-or-later"
  head "https://hg.sr.ht/~breakfastquay/rubberband", using: :hg

  livecheck do
    url :homepage
    regex(/href=.*?rubberband[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rubberband"
    rebuild 2
    sha256 cellar: :any, mojave: "8cc8be9059bf5a2686e09b08b1408fa3482545e5560eca3f0cabcc9a26387099"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "libsamplerate"
  depends_on "libsndfile"

  on_linux do
    depends_on "fftw"
    depends_on "gcc"
    depends_on "ladspa-sdk"
    depends_on "openjdk"
    depends_on "vamp-plugin-sdk"
  end

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "meson", *std_meson_args
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    output = shell_output("#{bin}/rubberband -t2 #{test_fixtures("test.wav")} out.wav 2>&1")
    assert_match "Pass 2: Processing...", output
  end
end
