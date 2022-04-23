class Repo < Formula
  include Language::Python::Shebang

  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://gerrit.googlesource.com/git-repo.git",
      tag:      "v2.24",
      revision: "4c11aebeb934817407266787d58247e1ca802057"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b52e21bffaecf122a7c5473ce62757a144d176a8991217caac67d56619e08c6e"
  end

  depends_on "python@3.10"

  def install
    bin.install "repo"
    rewrite_shebang detected_python_shebang, bin/"repo"

    doc.install (buildpath/"docs").children
  end

  test do
    assert_match "usage:", shell_output("#{bin}/repo help 2>&1")
  end
end
