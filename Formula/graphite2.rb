class Graphite2 < Formula
  desc "Smart font renderer for non-Roman scripts"
  homepage "https://graphite.sil.org/"
  url "https://github.com/silnrsi/graphite/releases/download/1.3.14/graphite2-1.3.14.tgz"
  sha256 "f99d1c13aa5fa296898a181dff9b82fb25f6cc0933dbaa7a475d8109bd54209d"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later", "MPL-1.1+"]
  head "https://github.com/silnrsi/graphite.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/graphite2"
    rebuild 1
    sha256 cellar: :any, mojave: "aa246400a83cedc1df068fad0fb5a09dc7f6c12b20d20a2060d751446e4381ba"
  end


  depends_on "cmake" => :build

  on_linux do
    depends_on "freetype" => :build
  end

  resource "testfont" do
    url "https://scripts.sil.org/pub/woff/fonts/Simple-Graphite-Font.ttf"
    sha256 "7e573896bbb40088b3a8490f83d6828fb0fd0920ac4ccdfdd7edb804e852186a"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    resource("testfont").stage do
      shape = shell_output("#{bin}/gr2fonttest Simple-Graphite-Font.ttf 'abcde'")
      assert_match(/67.*36.*37.*38.*71/m, shape)
    end
  end
end
