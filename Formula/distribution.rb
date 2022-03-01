class Distribution < Formula
  desc "Create ASCII graphical histograms in the terminal"
  homepage "https://github.com/philovivero/distribution"
  url "https://github.com/philovivero/distribution/archive/1.3.tar.gz"
  sha256 "d7f2c9beeee15986d24d8068eb132c0a63c0bd9ace932e724cb38c1e6e54f95d"
  license "GPL-2.0"
  head "https://github.com/philovivero/distribution.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/distribution"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "a1a4c268b4aa613ed47ca0bcf4b5526e534b547bfa49e5a5bdb7d90ed1f1d497"
  end


  def install
    bin.install "distribution.py" => "distribution"
    doc.install "distributionrc", "screenshot.png"
  end

  test do
    (testpath/"test").write "a\nb\na\n"
    `#{bin}/distribution <test 2>/dev/null`.include? "a|2"
  end
end
