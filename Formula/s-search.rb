class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/v0.6.6.tar.gz"
  sha256 "d91c8d2935f55dc6f241b7abc0325863846bdeac07a8f3bfa99b4a932d20ace3"
  license "MIT"
  head "https://github.com/zquestz/s.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/s-search"
    sha256 cellar: :any_skip_relocation, mojave: "d21aefee749d82bb18425e17da8f7e01508f1f52b8d440b7308c6f975db6e99e"
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
