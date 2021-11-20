class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://github.com/stacked-git/stgit/releases/download/v1.4/stgit-1.4.tar.gz"
  sha256 "145cacd89127a31e0363e4e6a7997fb0510c193d4669aa7f614dd6a8b5def1af"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/stgit"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "58a2f0196b8431d64ad7473183253231929feecc2b6ff4bfbedac7f30dda03cd"
  end

  depends_on "asciidoc" => :build
  depends_on "xmlto" => :build
  depends_on "python@3.10"

  def install
    ENV["PYTHON"] = Formula["python@3.10"].opt_bin/"python3"
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "make", "prefix=#{prefix}", "all"
    system "make", "prefix=#{prefix}", "install"
    system "make", "prefix=#{prefix}", "install-doc"
    bash_completion.install "completion/stgit.bash"
    fish_completion.install "completion/stg.fish"
    zsh_completion.install "completion/stgit.zsh" => "_stgit"
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "brew@test.bot"
    (testpath/"test").write "test"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit", "test"
    system "#{bin}/stg", "--version"
    system "#{bin}/stg", "init"
    system "#{bin}/stg", "new", "-m", "patch0"
    (testpath/"test").append_lines "a change"
    system "#{bin}/stg", "refresh"
    system "#{bin}/stg", "log"
  end
end
