class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://github.com/radareorg/sdb"
  url "https://github.com/radareorg/sdb/archive/1.9.0.tar.gz"
  sha256 "29c2dede43ad4eeecb330e0b0c6fbb332d8a72f7b183a9d946ed2603e0ae3720"
  license "MIT"
  head "https://github.com/radareorg/sdb.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sdb"
    sha256 cellar: :any, mojave: "66e8c19f17eba1acf4c8f627beed74173a70f32d9d6cb8ff20cc7478d60e6c17"
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
