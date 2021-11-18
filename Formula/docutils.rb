class Docutils < Formula
  include Language::Python::Virtualenv

  desc "Text processing system for reStructuredText"
  homepage "https://docutils.sourceforge.io"
  url "https://downloads.sourceforge.net/project/docutils/docutils/0.18/docutils-0.18.tar.gz"
  sha256 "c1d5dab2b11d16397406a282e53953fe495a46d69ae329f55aa98a5c4e3c5fbb"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/docutils"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "c5480ce8cf185bb07c091402d7ccfef2de6510e863402c43b2355a2a2745615c"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources

    Dir.glob("#{libexec}/bin/*.py") do |f|
      bin.install_symlink f => File.basename(f, ".py")
    end
  end

  test do
    system "#{bin}/rst2man.py", "#{prefix}/HISTORY.txt"
  end
end
