class GitNow < Formula
  desc "Light, temporary commits for git"
  homepage "https://github.com/iwata/git-now"
  license "GPL-2.0"
  head "https://github.com/iwata/git-now.git", branch: "master"

  stable do
    url "https://github.com/iwata/git-now.git",
        tag:      "v0.1.1.0",
        revision: "a07a05893b9ddf784833b3d4b410c843633d0f71"

    # Fix error on Linux due to /bin/sh using dash
    patch do
      url "https://github.com/iwata/git-now/commit/be74736cb95e8213cd06cc6fe85f467e26b9a3c2.patch?full_index=1"
      sha256 "6f13e7baeb0160e937221e51cd5736fabc57e3b8ba9309b88a8b17b5d14bb767"
    end
  end

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-now"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "2c42a8a6b1f1a950a2cf001b91da0b8547ab6ff70ba519af3b07940f8d9da943"
  end

  depends_on "gnu-getopt"

  def install
    system "make", "prefix=#{libexec}", "install"
    (bin/"git-now").write_env_script libexec/"bin/git-now", PATH: "#{Formula["gnu-getopt"].opt_bin}:$PATH"
    zsh_completion.install "etc/_git-now"
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    touch "file1"
    system "git", "init"
    system "git", "add", "file1"
    system bin/"git-now"
    assert_match "from now", shell_output("git log -1")
  end
end
