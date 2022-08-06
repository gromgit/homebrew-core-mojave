class Jpegoptim < Formula
  desc "Utility to optimize JPEG files"
  homepage "https://github.com/tjko/jpegoptim"
  url "https://github.com/tjko/jpegoptim/archive/RELEASE.1.4.7.tar.gz"
  sha256 "9d2a13b7c531d122f360209422645206931c74ada76497c4aeb953610f0d70c1"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/tjko/jpegoptim.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jpegoptim"
    sha256 cellar: :any, mojave: "c999aca7bae06e1674564d4569ac731724ec5672ebee8c53d65cfabb8370a3f8"
  end

  depends_on "jpeg-turbo"

  def install
    system "./configure", *std_configure_args
    ENV.deparallelize # Install is not parallel-safe
    system "make", "install"
  end

  test do
    source = test_fixtures("test.jpg")
    assert_match "OK", shell_output("#{bin}/jpegoptim --noaction #{source}")
  end
end
