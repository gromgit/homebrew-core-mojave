class Fdupes < Formula
  desc "Identify or delete duplicate files"
  homepage "https://github.com/adrianlopezroche/fdupes"
  url "https://github.com/adrianlopezroche/fdupes/releases/download/v2.2.1/fdupes-2.2.1.tar.gz"
  sha256 "846bb79ca3f0157856aa93ed50b49217feb68e1b35226193b6bc578be0c5698d"
  license "MIT"
  version_scheme 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fdupes"
    sha256 cellar: :any, mojave: "b8df60268535843d8434d014498625ca96f246c5749b8e5c38a26aada4c11959"
  end

  depends_on "pcre2"

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    touch "a"
    touch "b"

    dupes = shell_output("#{bin}/fdupes .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end
