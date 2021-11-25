class Docutils < Formula
  include Language::Python::Virtualenv

  desc "Text processing system for reStructuredText"
  homepage "https://docutils.sourceforge.io"
  url "https://downloads.sourceforge.net/project/docutils/docutils/0.18.1/docutils-0.18.1.tar.gz"
  sha256 "679987caf361a7539d76e584cbeddc311e3aee937877c87346f31debc63e9d06"
  license all_of: [:public_domain, "BSD-2-Clause", "GPL-3.0-or-later", "Python-2.0"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/docutils"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "69e2a2ac59d1ca2678d3c713263ab1b847f9604d02a6bdb7427172f07c958086"
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
