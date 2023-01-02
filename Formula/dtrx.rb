class Dtrx < Formula
  include Language::Python::Virtualenv

  desc "Intelligent archive extraction"
  homepage "https://pypi.org/project/dtrx/"
  url "https://files.pythonhosted.org/packages/3b/3b/426aacf32cfc661b1adbb61f3285367e9aff083252fd369a76bd3f565876/dtrx-8.5.0.tar.gz"
  sha256 "66e2e1d5bf98401aec70c44e78192ca478d2138c7a6395863e51d07b085355b0"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dtrx"
    sha256 cellar: :any_skip_relocation, mojave: "09a757e9c313cec509b7178db7de0b856f6a540fabc56426e58e3a842b7c961e"
  end

  # Include a few common decompression handlers in addition to the python dep
  depends_on "p7zip"
  depends_on "python@3.11"
  depends_on "xz"

  uses_from_macos "zip" => :test
  uses_from_macos "bzip2"
  uses_from_macos "unzip"

  def install
    virtualenv_install_with_resources
  end

  # Test a simple unzip. Sample taken from unzip formula
  test do
    (testpath/"test1").write "Hello!"
    (testpath/"test2").write "Bonjour!"
    (testpath/"test3").write "Hej!"

    system "zip", "test.zip", "test1", "test2", "test3"
    %w[test1 test2 test3].each do |f|
      rm f
      refute_predicate testpath/f, :exist?, "Text files should have been removed!"
    end

    system "#{bin}/dtrx", "--flat", "test.zip"

    %w[test1 test2 test3].each do |f|
      assert_predicate testpath/f, :exist?, "Failure unzipping test.zip!"
    end

    assert_equal "Hello!", (testpath/"test1").read
    assert_equal "Bonjour!", (testpath/"test2").read
    assert_equal "Hej!", (testpath/"test3").read
  end
end
