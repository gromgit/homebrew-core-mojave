class Kakoune < Formula
  desc "Selection-based modal text editor"
  homepage "https://github.com/mawww/kakoune"
  url "https://github.com/mawww/kakoune/releases/download/v2021.11.08/kakoune-2021.11.08.tar.bz2"
  sha256 "aa30889d9da11331a243a8f40fe4f6a8619321b19217debac8f565e06eddb5f4"
  license "Unlicense"
  head "https://github.com/mawww/kakoune.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kakoune"
    rebuild 5
    sha256 cellar: :any_skip_relocation, mojave: "ae845287c8b2f368e2cd281eb3a2c10c4e935c13d54977a7025cc9301bec4013"
  end

  depends_on macos: :high_sierra # needs C++17
  depends_on "ncurses"

  uses_from_macos "libxslt" => :build

  on_linux do
    depends_on "binutils" => :build
    depends_on "linux-headers@5.15" => :build
    depends_on "pkg-config" => :build
  end

  fails_with gcc: "5"
  fails_with gcc: "6"

  def install
    cd "src" do
      system "make", "install", "debug=no", "PREFIX=#{prefix}"
    end
  end

  test do
    system bin/"kak", "-ui", "dummy", "-e", "q"
  end
end
