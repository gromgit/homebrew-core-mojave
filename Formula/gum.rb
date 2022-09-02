class Gum < Formula
  desc "Tool for glamorous shell scripts"
  homepage "https://github.com/charmbracelet/gum"
  url "https://github.com/charmbracelet/gum/archive/v0.5.0.tar.gz"
  sha256 "0f8e071cc3610c641cc0539f7feb9652b0e8a1fa8f7409c81625cbe71027f28e"
  license "MIT"
  head "https://github.com/charmbracelet/gum.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gum"
    sha256 cellar: :any_skip_relocation, mojave: "fae968ce83f246d353e1f019115bebbb64c161fa1f2e04a109ca681a36fde515"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")

    man_page = Utils.safe_popen_read(bin/"gum", "man")
    (man1/"gum.1").write man_page

    bash_output = Utils.safe_popen_read(bin/"gum", "completion", "bash")
    (bash_completion/"gum").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"gum", "completion", "zsh")
    (zsh_completion/"_gum").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"gum", "completion", "fish")
    (fish_completion/"gum.fish").write fish_output
  end

  test do
    assert_match "Gum", shell_output("#{bin}/gum format 'Gum'").chomp
    assert_equal "foo", shell_output("#{bin}/gum style foo").chomp
    assert_equal "foo\nbar", shell_output("#{bin}/gum join --vertical foo bar").chomp
    assert_equal "foobar", shell_output("#{bin}/gum join foo bar").chomp
  end
end
