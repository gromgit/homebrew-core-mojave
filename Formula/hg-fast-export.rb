class HgFastExport < Formula
  include Language::Python::Shebang

  desc "Fast Mercurial to Git converter"
  homepage "https://repo.or.cz/fast-export.git"
  url "https://github.com/frej/fast-export/archive/v210917.tar.gz"
  sha256 "168f51301f01b4a2572bb00dd9474ee9a50b85f24aa5ed5a7b8abb12896d951a"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1c3c08a5e4f6fbb7790d42d5721db3d8b4927a5595056fbc27b90d6171b9c8b4"
  end

  depends_on "mercurial"
  depends_on "python@3.10"

  def install
    # The Python executable is tested from PATH
    # Prepend ours Python to the executable candidate list (python2 python python3)
    # See https://github.com/Homebrew/homebrew-core/pull/90709#issuecomment-988548657
    %w[hg-fast-export.sh hg-reset.sh].each do |f|
      inreplace f, "for python_cmd in ",
                   "for python_cmd in '#{which("python3")}' "
    end

    libexec.install Dir["*"]

    %w[hg-fast-export.py hg-fast-export.sh hg-reset.py hg-reset.sh hg2git.py].each do |f|
      rewrite_shebang detected_python_shebang, libexec/f
      bin.install_symlink libexec/f
    end
  end

  test do
    mkdir testpath/"hg-repo" do
      system "hg", "init"
      (testpath/"hg-repo/test.txt").write "Hello"
      system "hg", "add", "test.txt"
      system "hg", "commit", "-u", "test@test", "-m", "test"
    end

    mkdir testpath/"git-repo" do
      system "git", "init"
      system "git", "config", "core.ignoreCase", "false"
      system "hg-fast-export.sh", "-r", "#{testpath}/hg-repo"
      system "git", "checkout", "HEAD"
    end

    assert_predicate testpath/"git-repo/test.txt", :exist?
    assert_equal "Hello", (testpath/"git-repo/test.txt").read
  end
end
