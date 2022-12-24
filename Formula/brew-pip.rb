class BrewPip < Formula
  include Language::Python::Shebang

  desc "Install pip packages as homebrew formulae"
  homepage "https://github.com/hanxue/brew-pip"
  url "https://github.com/hanxue/brew-pip/archive/0.4.1.tar.gz"
  sha256 "9049a6db97188560404d8ecad2a7ade72a4be4338d5241097d3e3e8e215cda28"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/brew-pip"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "d06a7bf79cd911d10bb3dc6679a7e47fb61b0beaa3ab86eb75dd6ef6d1c67823"
  end

  # Repository is not maintained in 9+ years
  deprecate! date: "2022-04-16", because: :unmaintained

  depends_on "python@3.11"

  def install
    bin.install "bin/brew-pip"
    rewrite_shebang detected_python_shebang, bin/"brew-pip"
  end

  test do
    system "#{bin}/brew-pip", "--help"
  end
end
