class Httpdiff < Formula
  desc "Compare two HTTP(S) responses"
  homepage "https://github.com/jgrahamc/httpdiff"
  url "https://github.com/jgrahamc/httpdiff/archive/v1.0.0.tar.gz"
  sha256 "b2d3ed4c8a31c0b060c61bd504cff3b67cd23f0da8bde00acd1bfba018830f7f"
  license "GPL-2.0"
  head "https://github.com/jgrahamc/httpdiff.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/httpdiff"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "c2671a62b3b9b4e916452939b2018c7a3ff119ac01fc5a9ea1b806460af7b80c"
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "auto"
    system "go", "build", "-o", bin/"httpdiff"
  end

  test do
    system bin/"httpdiff", "https://brew.sh/", "https://brew.sh/"
  end
end
