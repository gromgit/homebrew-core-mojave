class Cocogitto < Formula
  desc "Conventional Commits toolbox"
  homepage "https://github.com/cocogitto/cocogitto"
  url "https://github.com/cocogitto/cocogitto/archive/refs/tags/5.2.0.tar.gz"
  sha256 "99f9dee05597d7721f6d046dbfefba5cb8d1c4ae22ced415f724affb3a6bd0cc"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cocogitto"
    sha256 cellar: :any_skip_relocation, mojave: "1f25f4c1231775a6178ba332e83b58e9ec8899a024eaa03154a0b996510a3540"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"cog", "generate-completions", base_name: "cog")
  end

  test do
    # Check that a typical Conventional Commit is considered correct.
    system "git", "init"
    (testpath/"some-file").write("")
    system "git", "add", "some-file"
    system "git", "config", "user.name", "'A U Thor'"
    system "git", "config", "user.email", "author@example.com"
    system "git", "commit", "-m", "chore: initial commit"
    assert_equal "No errored commits", shell_output("#{bin}/cog check 2>&1").strip
  end
end
