class Gum < Formula
  desc "Tool for glamorous shell scripts"
  homepage "https://github.com/charmbracelet/gum"
  url "https://github.com/charmbracelet/gum/archive/v0.2.0.tar.gz"
  sha256 "85bf131216c5ce7fdfc1c8c72d2eca43d4a57e4ce323792f386317b6bfffb032"
  license "MIT"
  head "https://github.com/charmbracelet/gum.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gum"
    sha256 cellar: :any_skip_relocation, mojave: "736996c0f8def0c149ee555935056608a51e0218bb51c3a2071a563530c304fa"
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
