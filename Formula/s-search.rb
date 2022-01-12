class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/v0.6.4.tar.gz"
  sha256 "5829a18da40cb5a936f32240b4244d2a0543cb85dc3d5e013ae5aa08557c148f"
  license "MIT"
  head "https://github.com/zquestz/s.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/s-search"
    sha256 cellar: :any_skip_relocation, mojave: "17137a827a46d71ccecef35d02d658cef71ae0b7bc49a654c5447e87e8ef0030"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/"s"

    output = Utils.safe_popen_read("#{bin}/s", "--completion", "bash")
    (bash_completion/"s-completion.bash").write output

    output = Utils.safe_popen_read("#{bin}/s", "--completion", "zsh")
    (zsh_completion/"_s").write output

    output = Utils.safe_popen_read("#{bin}/s", "--completion", "fish")
    (fish_completion/"s.fish").write output
  end

  test do
    output = shell_output("#{bin}/s -p bing -b echo homebrew")
    assert_equal "https://www.bing.com/search?q=homebrew", output.chomp
  end
end
