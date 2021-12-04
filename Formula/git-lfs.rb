class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/releases/download/v3.0.2/git-lfs-v3.0.2.tar.gz"
  sha256 "7179a357a0d0e7beaba217489f7f784ca8717035a5e3f1ee91ca7193ba3a35f3"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-lfs"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "c356e25067fff03ea26671e55a9e2ca1064a77665b23f5a091ee1e4bc75f03ec"
  end

  depends_on "go" => :build
  depends_on "ronn" => :build
  depends_on "ruby" => :build

  def install
    ENV["GIT_LFS_SHA"] = ""
    ENV["VERSION"] = version

    (buildpath/"src/github.com/git-lfs/git-lfs").install buildpath.children
    cd "src/github.com/git-lfs/git-lfs" do
      system "make", "vendor"
      system "make"
      system "make", "man", "RONN=#{Formula["ronn"].bin}/ronn"

      bin.install "bin/git-lfs"
      man1.install Dir["man/*.1"]
      man5.install Dir["man/*.5"]
      doc.install Dir["man/*.html"]
    end
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
