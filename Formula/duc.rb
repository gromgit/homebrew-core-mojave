class Duc < Formula
  desc "Suite of tools for inspecting disk usage"
  homepage "https://duc.zevv.nl/"
  url "https://github.com/zevv/duc/releases/download/1.4.4/duc-1.4.4.tar.gz"
  sha256 "f4e7483dbeca4e26b003548f9f850b84ce8859bba90da89c55a7a147636ba922"
  license "LGPL-3.0"
  revision 1
  head "https://github.com/zevv/duc.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/duc"
    rebuild 1
    sha256 cellar: :any, mojave: "cb909f50e1919c43bb21b0bb5b82fa2b771ab108489cdb179bf7a532e882d30b"
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
    system "dd", "if=/dev/zero", "of=test", "count=1"
    system "#{bin}/duc", "index", "."
    system "#{bin}/duc", "graph", "-o", "duc.png"
    assert_predicate testpath/"duc.png", :exist?, "Failed to create duc.png!"
  end
end
