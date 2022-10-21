class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/r27.tar.gz"
  sha256 "cdd132e33387423ef9f9448e21d3f1e5c9a5319b34fdfb53cb5f49351ebac005"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lf"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "ffcec518d849189e3468bb4c641cfe35a5bcfd2b640ce72af63e32d61d0606e5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.gVersion=#{version}")
    man1.install "lf.1"
    zsh_completion.install "etc/lf.zsh" => "_lf"
    fish_completion.install "etc/lf.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/lf -version").chomp
    assert_match "file manager", shell_output("#{bin}/lf -doc")
  end
end
