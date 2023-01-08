class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://github.com/orhun/git-cliff"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "c77b7b38edae80b3a66c96f15d0bc3eaaa0bc55e1d3fbc8187c55070306188c1"
  license "GPL-3.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-cliff"
    sha256 cellar: :any_skip_relocation, mojave: "f52a4ee756b2b4248ab7be707853a76bc006d29d9fb47145ce6b23a7da3d0862"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "git-cliff")

    ENV["OUT_DIR"] = buildpath
    system bin/"git-cliff-completions"
    bash_completion.install "git-cliff.bash"
    fish_completion.install "git-cliff.fish"
    zsh_completion.install "_git-cliff"
  end

  test do
    system "git", "cliff", "--init"
    assert_predicate testpath/"cliff.toml", :exist?

    system "git", "init"
    system "git", "add", "cliff.toml"
    system "git", "commit", "-m", "chore: initial commit"
    changelog = "### Miscellaneous Tasks\n\n- Initial commit"
    assert_match changelog, shell_output("git cliff")
  end
end
