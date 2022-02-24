class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://github.com/radare/sdb"
  url "https://github.com/radareorg/sdb/archive/1.8.4.tar.gz"
  sha256 "496a773fdf85c400f00b9b73bc13e4e6588f9293594e959958a17e9b43961b34"
  license "MIT"
  head "https://github.com/radare/sdb.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sdb"
    sha256 cellar: :any, mojave: "cbe283c1b23683580fe14bd77c339f8d5a6088f27f28bf1bbc1c07c43735c0ea"
  end

  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"sdb", testpath/"d", "hello=world"
    assert_equal "world", shell_output("#{bin}/sdb #{testpath}/d hello").strip
  end
end
