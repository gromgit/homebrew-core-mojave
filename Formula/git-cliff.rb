class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://github.com/orhun/git-cliff"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "451db5e7ce904f33cf5772cd67400015829e5b7b3d18955bc3e8f88977b63793"
  license "GPL-3.0-only"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-cliff"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "2a0e61898ce7f4a76e13787df68fa093da6bb4c2d9c1d921acc3216e863103e9"
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
