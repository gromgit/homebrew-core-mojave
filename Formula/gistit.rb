class Gistit < Formula
  desc "Command-line utility for creating Gists"
  homepage "https://gistit.herokuapp.com/"
  url "https://github.com/jrbasso/gistit/archive/v0.1.4.tar.gz"
  sha256 "9d87cfdd6773ebbd3f6217b11d9ebcee862ee4db8be7e18a38ebb09634f76a78"
  license "MIT"
  head "https://github.com/jrbasso/gistit.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gistit"
    rebuild 1
    sha256 cellar: :any, mojave: "2412771037c1ae9daba3a7ac17230837f338c137739d94981d0ee5b698b3ffd3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "jansson"

  def install
    mv "configure.in", "configure.ac" # silence warning
    system "./autogen.sh", "--disable-dependency-tracking",
                           "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/gistit", "-v"
  end
end
