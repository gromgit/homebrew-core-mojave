class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://github.com/jbruchon/jdupes"
  url "https://github.com/jbruchon/jdupes/archive/v1.20.2.tar.gz"
  sha256 "d079d22dc77e1d181abcb8a59216520633a8712d197d007a9a9fb64c72610824"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jdupes"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "740048360aa52ce9b8224b3d2627d7f8b00ac3ed872a6496effa7baa6f4dab7a"
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
