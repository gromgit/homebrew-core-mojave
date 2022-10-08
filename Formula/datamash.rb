class Datamash < Formula
  desc "Tool to perform numerical, textual & statistical operations"
  homepage "https://www.gnu.org/software/datamash"
  url "https://ftp.gnu.org/gnu/datamash/datamash-1.8.tar.gz"
  mirror "https://ftpmirror.gnu.org/datamash/datamash-1.8.tar.gz"
  sha256 "7ad97e8c7ef616dd03aa5bd67ae24c488272db3e7d1f5774161c18b75f29f6fd"
  license "GPL-3.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/datamash"
    sha256 mojave: "06affcd4e928cc164da2725a2023a9a67b9e03b95f4596d347552071a18851fd"
  end

  head do
    url "https://git.savannah.gnu.org/git/datamash.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "55", pipe_output("#{bin}/datamash sum 1", shell_output("seq 10")).chomp
  end
end
