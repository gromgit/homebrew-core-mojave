class Ttygif < Formula
  desc "Converts a ttyrec file into gif files"
  homepage "https://github.com/icholy/ttygif"
  url "https://github.com/icholy/ttygif/archive/1.6.0.tar.gz"
  sha256 "050b9e86f98fb790a2925cea6148f82f95808d707735b2650f3856cb6f53e0ae"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ttygif"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "bb3d4706fcc52f420947df432423bb105917120ed887f2feabe56c5614fad53e"
  end

  depends_on "imagemagick"
  depends_on "ttyrec"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Disable test on Linux because it fails with this error:
    # Error: WINDOWID environment variable was empty.
    # This is expected as a valid X window ID is required:
    # https://walialu.com/ttygif-error-windowid-environment-variable-was-empty
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    ENV["TERM_PROGRAM"] = "Something"
    system "#{bin}/ttygif", "--version"
  end
end
