class GitAbsorb < Formula
  desc "Automatic git commit --fixup"
  homepage "https://github.com/tummychow/git-absorb"
  url "https://github.com/tummychow/git-absorb/archive/0.6.7.tar.gz"
  sha256 "f562dbcf68c5f687197e8a594cb58cf102cc17a2e9fcf66dbacb83b49e053bd7"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-absorb"
    sha256 cellar: :any_skip_relocation, mojave: "b2fa05826ea4afc029304c3d467eeadbf5355ac88d5b494042cf6ff0321811de"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "Documentation/git-absorb.1"

    (zsh_completion/"_git-absorb").write Utils.safe_popen_read("#{bin}/git-absorb", "--gen-completions", "zsh")
    (bash_completion/"git-absorb").write Utils.safe_popen_read("#{bin}/git-absorb", "--gen-completions", "bash")
    (fish_completion/"git-absorb.fish").write Utils.safe_popen_read("#{bin}/git-absorb", "--gen-completions", "fish")
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    system "git", "init"
    (testpath/"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit"

    (testpath/"test").delete
    (testpath/"test").write "bar"
    system "git", "add", "test"
    system "git", "absorb"
  end
end
