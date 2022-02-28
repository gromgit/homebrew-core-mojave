class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://github.com/radare/sdb"
  url "https://github.com/radareorg/sdb/archive/1.8.6.tar.gz"
  sha256 "0fbbbb577dec318d79cd110251a6a469460955dc49aa52b6f7796a6a7b478b00"
  license "MIT"
  head "https://github.com/radare/sdb.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sdb"
    sha256 cellar: :any, mojave: "4de9001e6fd001021bb4bb22999bf852b171fac0739d6ccf38035ac8c94948fa"
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
