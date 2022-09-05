class Exa < Formula
  desc "Modern replacement for 'ls'"
  homepage "https://the.exa.website"
  url "https://github.com/ogham/exa/archive/v0.10.1.tar.gz"
  sha256 "ff0fa0bfc4edef8bdbbb3cabe6fdbd5481a71abbbcc2159f402dea515353ae7c"
  license "MIT"
  head "https://github.com/ogham/exa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/exa"
    rebuild 3
    sha256 cellar: :any_skip_relocation, mojave: "ad0ed6aa48f52cad54975ca0c57a9c77886b2436c5378a557674cfde9bdc7274"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "libgit2"
  end

  def install
    system "cargo", "install", *std_cargo_args

    if build.head?
      bash_completion.install "completions/bash/exa"
      zsh_completion.install  "completions/zsh/_exa"
      fish_completion.install "completions/fish/exa.fish"
    else
      # Remove after >0.10.1 build
      bash_completion.install "completions/completions.bash" => "exa"
      zsh_completion.install  "completions/completions.zsh"  => "_exa"
      fish_completion.install "completions/completions.fish" => "exa.fish"
    end

    args = %w[
      --standalone
      --to=man
    ]
    system "pandoc", *args, "man/exa.1.md", "-o", "exa.1"
    system "pandoc", *args, "man/exa_colors.5.md", "-o", "exa_colors.5"
    man1.install "exa.1"
    man5.install "exa_colors.5"
  end

  test do
    (testpath/"test.txt").write("")
    assert_match "test.txt", shell_output("#{bin}/exa")
  end
end
