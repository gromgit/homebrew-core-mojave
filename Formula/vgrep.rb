class Vgrep < Formula
  desc "User-friendly pager for grep"
  homepage "https://github.com/vrothberg/vgrep"
  url "https://github.com/vrothberg/vgrep/archive/v2.6.0.tar.gz"
  sha256 "4cbd912189397b08897fcc1709787ec60ed42275059f900463055211e1f6d689"
  license "GPL-3.0-only"
  version_scheme 1
  head "https://github.com/vrothberg/vgrep.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/vgrep"
    sha256 cellar: :any_skip_relocation, mojave: "5aacf51662cf55d3ae3281c2ee50bb1e1321ffe176db82bc54414af0f453ac14"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  def install
    system "make", "release"
    mkdir bin
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.txt").write "Hello from Homebrew!\n"
    output = shell_output("#{bin}/vgrep -w Homebrew --no-less .")
    assert_match "Hello from", output
    assert_match "Homebrew", output
  end
end
