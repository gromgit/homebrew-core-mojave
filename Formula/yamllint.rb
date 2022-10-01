class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://files.pythonhosted.org/packages/c8/82/4cd3ec8f98d821e7cc7ef504add450623d5c86b656faf65e9b0cc46f4be6/yamllint-1.28.0.tar.gz"
  sha256 "9e3d8ddd16d0583214c5fdffe806c9344086721f107435f68bad990e5a88826b"
  license "GPL-3.0-or-later"
  head "https://github.com/adrienverge/yamllint.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/yamllint"
    sha256 cellar: :any_skip_relocation, mojave: "9f5cc20858452c722a3ed5691190d8516315ff61303c3ef19ac3e506bd52d942"
  end

  depends_on "python@3.10"
  depends_on "pyyaml"

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/24/9f/a9ae1e6efa11992dba2c4727d94602bd2f6ee5f0dedc29ee2d5d572c20f7/pathspec-0.10.1.tar.gz"
    sha256 "7ace6161b621d31e7902eb6b5ae148d12cfd23f4a249b9ffb6b9fee12084323d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"bad.yaml").write <<~EOS
      ---
      foo: bar: gee
    EOS
    output = shell_output("#{bin}/yamllint -f parsable -s bad.yaml", 1)
    assert_match "syntax error: mapping values are not allowed here", output

    (testpath/"good.yaml").write <<~EOS
      ---
      foo: bar
    EOS
    assert_equal "", shell_output("#{bin}/yamllint -f parsable -s good.yaml")
  end
end
