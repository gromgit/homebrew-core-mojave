class Quilt < Formula
  desc "Work with series of patches"
  homepage "https://savannah.nongnu.org/projects/quilt"
  url "https://download.savannah.gnu.org/releases/quilt/quilt-0.67.tar.gz"
  sha256 "3be3be0987e72a6c364678bb827e3e1fcc10322b56bc5f02b576698f55013cc2"
  license "GPL-2.0-or-later"
  head "https://git.savannah.gnu.org/git/quilt.git", branch: "master"

  livecheck do
    url "https://download.savannah.gnu.org/releases/quilt/"
    regex(/href=.*?quilt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/quilt"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "77c5f7bc7503600bdb4ba6e2207140ac6cd3029201d78d3144cfc662d08ea44b"
  end

  depends_on "coreutils"
  depends_on "gnu-sed"

  def install
    args = [
      "--prefix=#{prefix}",
      "--without-getopt",
    ]
    if OS.mac?
      args << "--with-sed=#{HOMEBREW_PREFIX}/bin/gsed"
      args << "--with-stat=/usr/bin/stat" # on macOS, quilt expects BSD stat
    else
      args << "--with-sed=#{HOMEBREW_PREFIX}/bin/sed"
    end
    system "./configure", *args

    system "make"
    system "make", "install", "emacsdir=#{elisp}"
  end

  test do
    (testpath/"patches").mkpath
    (testpath/"test.txt").write "Hello, World!"
    system bin/"quilt", "new", "test.patch"
    system bin/"quilt", "add", "test.txt"
    rm "test.txt"
    (testpath/"test.txt").write "Hi!"
    system bin/"quilt", "refresh"
    assert_match(/-Hello, World!/, File.read("patches/test.patch"))
    assert_match(/\+Hi!/, File.read("patches/test.patch"))
  end
end
