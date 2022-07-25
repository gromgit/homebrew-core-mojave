class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.20.0-source.tar.lz"
  sha256 "68dbb1cf5e31603380ce3f1c7f6c431ad442fa735d048700f50ab4de4c3b0f82"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    url "https://mupdf.com/downloads/archive/"
    regex(/href=.*?mupdf[._-]v?(\d+(?:\.\d+)+)-source\.(?:t|zip)/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mupdf"
    sha256 cellar: :any, mojave: "f276a8a879f17088b2006083628e7fc6eca295c728ea2a0351733934285b72c0"
  end

  depends_on "pkg-config" => :build
  depends_on "freeglut"
  depends_on "mesa"

  conflicts_with "mupdf-tools",
    because: "mupdf and mupdf-tools install the same binaries"

  def install
    glut_cflags = `pkg-config --cflags glut gl`.chomp
    glut_libs = `pkg-config --libs glut gl`.chomp
    system "make", "install",
           "build=release",
           "shared=yes",
           "verbose=yes",
           "CC=#{ENV.cc}",
           "SYS_GLUT_CFLAGS=#{glut_cflags}",
           "SYS_GLUT_LIBS=#{glut_libs}",
           "prefix=#{prefix}"

    # Symlink `mutool` as `mudraw` (a popular shortcut for `mutool draw`).
    bin.install_symlink bin/"mutool" => "mudraw"
    man1.install_symlink man1/"mutool.1" => "mudraw.1"

    lib.install_symlink lib/shared_library("libmupdf") => shared_library("libmupdf-third")
  end

  test do
    assert_match "Homebrew test", shell_output("#{bin}/mudraw -F txt #{test_fixtures("test.pdf")}")
  end
end
