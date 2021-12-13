class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/v0.6.2.tar.gz"
  sha256 "acc38953fcb21e1dd2cd761b9d2bf8272aa6aa30fed2adb657f2dba7e4df872f"
  license "MIT"
  head "https://github.com/zquestz/s.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/s-search"
    sha256 cellar: :any_skip_relocation, mojave: "597e560fc994241ce7ecff7bd2166decae5967a3b11825947aafdf1cfedb9d08"
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
