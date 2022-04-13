class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.19.1-source.tar.xz"
  sha256 "b5eac663fe74f33c430eda342f655cf41fa73d71610f0884768a856a82e3803e"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mupdf-tools"
    sha256 cellar: :any_skip_relocation, mojave: "2b6c3b9d86306440227c472d5b2855de8ac11480b5493061d47db0e4ea93de5a"
  end

  conflicts_with "mupdf",
    because: "mupdf and mupdf-tools install the same binaries"

  def install
    system "make", "install",
           "build=release",
           "verbose=yes",
           "HAVE_X11=no",
           "HAVE_GLUT=no",
           "CC=#{ENV.cc}",
           "prefix=#{prefix}"

    # Symlink `mutool` as `mudraw` (a popular shortcut for `mutool draw`).
    bin.install_symlink bin/"mutool" => "mudraw"
    man1.install_symlink man1/"mutool.1" => "mudraw.1"
  end

  test do
    assert_match "Homebrew test", shell_output("#{bin}/mudraw -F txt #{test_fixtures("test.pdf")}")
  end
end
