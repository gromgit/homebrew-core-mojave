class Duc < Formula
  desc "Suite of tools for inspecting disk usage"
  homepage "https://duc.zevv.nl/"
  url "https://github.com/zevv/duc/releases/download/1.4.5/duc-1.4.5.tar.gz"
  sha256 "c69512ca85b443e42ffbb4026eedd5492307af612047afb9c469df923b468bfd"
  license "LGPL-3.0"
  head "https://github.com/zevv/duc.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/duc"
    sha256 cellar: :any, mojave: "78654c5d2b759b8477f9fed443efd7706f482f9fedbd36a39e9a0ef6d5bc8ce0"
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "glfw"
  depends_on "pango"
  depends_on "tokyo-cabinet"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-x11",
                          "--enable-opengl"
    system "make", "install"
  end

  test do
    db_file = testpath/"duc.db"
    touch db_file
    system "dd", "if=/dev/zero", "of=test", "count=1"
    system "#{bin}/duc", "index", "-d", db_file, "."
    system "#{bin}/duc", "graph", "-d", db_file, "-o", "duc.png"
    assert_predicate testpath/"duc.png", :exist?, "Failed to create duc.png!"
  end
end
