class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://github.com/jbruchon/jdupes"
  url "https://github.com/jbruchon/jdupes/archive/v1.21.0.tar.gz"
  sha256 "13e56c608354f10f9314c99cf37b034dde14e6bf4a9303c77391323e2ef4f549"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jdupes"
    sha256 cellar: :any_skip_relocation, mojave: "0427b07cec341f8e3adc3682ad2f2eb83fd1b87a5c491424a28a5f852891a3d2"
  end

  # Fix build failure. Remove in next release.
  patch do
    url "https://github.com/jbruchon/jdupes/commit/8f5b06109b44a9e4316f9445da3044590a6c63e2.patch?full_index=1"
    sha256 "0dd00247bdee3252750c629e3a9c00cb63e8d5cfe383b9a9989ac6748d264880"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "ENABLE_DEDUPE=1"
  end

  test do
    touch "a"
    touch "b"
    (testpath/"c").write("unique file")
    dupes = shell_output("#{bin}/jdupes --zeromatch .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end
