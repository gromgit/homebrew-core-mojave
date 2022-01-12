class Reminiscence < Formula
  desc "Flashback engine reimplementation"
  homepage "http://cyxdown.free.fr/reminiscence/"
  url "http://cyxdown.free.fr/reminiscence/REminiscence-0.4.9.tar.bz2"
  sha256 "320463e629c38f2e3aaaa510febacc0c5d88a59f5e906b0500a1dcb9c7e1e935"

  livecheck do
    url :homepage
    regex(/href=.*?REminiscence[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/reminiscence"
    sha256 cellar: :any, mojave: "cb5925316f38987b8bcc8a8f5f58f8544dec7dd1aa64e8fecddbec715be80199"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libmodplug"
  depends_on "libogg"
  depends_on "sdl2"

  uses_from_macos "zlib"

  resource "stb_vorbis" do
    url "https://raw.githubusercontent.com/nothings/stb/1ee679ca2ef753a528db5ba6801e1067b40481b8/stb_vorbis.c"
    sha256 "4c7cb2ff1f7011e9d67950446b7eb9ca044f2e464d76bfbb0b84dd2e23e65636"
    version "1.22"
  end

  resource "tremor" do
    url "https://gitlab.xiph.org/xiph/tremor.git",
        revision: "7c30a66346199f3f09017a09567c6c8a3a0eedc8"
  end

  def install
    resource("stb_vorbis").stage do
      buildpath.install "stb_vorbis.c"
    end

    resource("tremor").stage do
      system "./autogen.sh", "--disable-dependency-tracking",
                             "--disable-silent-rules",
                             "--prefix=#{libexec}",
                             "--disable-static"
      system "make", "install"
    end

    ENV.prepend "CPPFLAGS", "-I#{libexec}/include"
    ENV.prepend "LDFLAGS", "-L#{libexec}/lib"
    if OS.linux?
      # Fixes: reminiscence: error while loading shared libraries: libvorbisidec.so.1
      ENV.append "LDFLAGS", "-Wl,-rpath=#{libexec}/lib"
    end

    system "make"
    bin.install "rs" => "reminiscence"
  end

  test do
    system bin/"reminiscence", "--help"
  end
end
