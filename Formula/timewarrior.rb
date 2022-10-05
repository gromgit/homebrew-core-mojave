class Timewarrior < Formula
  desc "Command-line time tracking application"
  homepage "https://timewarrior.net/"
  url "https://github.com/GothenburgBitFactory/timewarrior/releases/download/v1.4.3/timew-1.4.3.tar.gz"
  sha256 "c4df7e306c9a267c432522c37958530b8fd6e5a410c058f575e25af4d8c7ca53"
  license "MIT"
  revision 1
  head "https://github.com/GothenburgBitFactory/timewarrior.git", branch: "dev"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/timewarrior"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "7d4faee848fa28e0484628d18ca88a0e1efcbee70ec9a52f183450b63a5f4b5f"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build

  on_linux do
    depends_on "man-db" => :test
  end

  fails_with gcc: "5"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/".timewarrior/data").mkpath
    (testpath/".timewarrior/extensions").mkpath
    touch testpath/".timewarrior/timewarrior.cfg"
    man = OS.mac? ? "man" : "gman"
    system man, "-P", "cat", "timew-summary"
    assert_match "Tracking foo", shell_output("#{bin}/timew start foo")
  end
end
