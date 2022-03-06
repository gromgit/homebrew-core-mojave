class GitMultipush < Formula
  desc "Push a branch to multiple remotes in one command"
  homepage "https://github.com/gavinbeatty/git-multipush"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/git-multipush/git-multipush-2.3.tar.bz2"
  sha256 "1f3b51e84310673045c3240048b44dd415a8a70568f365b6b48e7970afdafb67"
  license "GPL-3.0"
  head "https://github.com/gavinbeatty/git-multipush.git", branch: "main"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-multipush"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "cd06293f4893552f9825d6e318275e875855ca49d5f579228a5bfa51492ac91c"
  end

  depends_on "asciidoc" => :build

  def install
    system "make" if build.head?
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    # git-multipush will error even on --version if not in a repo
    system "git", "init"
    assert_match version.to_s, shell_output("#{bin}/git-multipush --version")
  end
end
