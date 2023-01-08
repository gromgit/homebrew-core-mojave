class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://git-lfs.github.com/"
  url "https://github.com/git-lfs/git-lfs/releases/download/v3.3.0/git-lfs-v3.3.0.tar.gz"
  sha256 "964c200bb7dcd6da44cbf0cfa88575f7e48d26925f8ec86d634d3f83306a0920"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-lfs"
    sha256 cellar: :any_skip_relocation, mojave: "955b6a6aefad6d224a91934e135561db8f8e845c81c48ecfa867f89a54d0242f"
  end

  depends_on "asciidoctor" => :build
  depends_on "go" => :build
  depends_on "ronn" => :build
  depends_on "ruby" => :build

  def install
    ENV["GIT_LFS_SHA"] = ""
    ENV["VERSION"] = version

    system "make"
    system "make", "man", "RONN=#{Formula["ronn"].bin}/ronn"

    bin.install "bin/git-lfs"
    man1.install Dir["man/man1/*.1"]
    man5.install Dir["man/man5/*.5"]
    man7.install Dir["man/man7/*.7"]
    doc.install Dir["man/html/*.html"]
  end

  def caveats
    <<~EOS
      Update your git config to finish installation:

        # Update global git config
        $ git lfs install

        # Update system git config
        $ git lfs install --system
    EOS
  end

  test do
    system "git", "init"
    system "git", "lfs", "track", "test"
    assert_match(/^test filter=lfs/, File.read(".gitattributes"))
  end
end
