class Jp2a < Formula
  desc "Convert JPG images to ASCII"
  homepage "https://csl.name/jp2a/"
  # Do not change source from SourceForge to GitHub until this issue is resolved:
  # https://github.com/cslarsen/jp2a/issues/8
  # Currently, GitHub only has jp2a v1.0.7, which is broken as described above.
  # jp2a v1.0.6 is stable, but it is only available on SourceForge, not GitHub.
  url "https://downloads.sourceforge.net/project/jp2a/jp2a/1.0.6/jp2a-1.0.6.tar.gz"
  sha256 "0930ac8a9545c8a8a65dd30ff80b1ae0d3b603f2ef83b04226da0475c7ccce1c"
  license "GPL-2.0"
  revision 2
  version_scheme 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jp2a"
    sha256 cellar: :any, mojave: "cef0deff1c1c0804436eb062abf5616538fade723a2b0c7a1a220b6c7db9d2c9"
  end

  depends_on "jpeg-turbo"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"jp2a", test_fixtures("test.jpg")
  end
end
