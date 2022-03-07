class Kona < Formula
  desc "Open-source implementation of the K programming language"
  homepage "https://github.com/kevinlawler/kona"
  url "https://github.com/kevinlawler/kona/archive/Win64-20211225.tar.gz"
  sha256 "cd5dcc03394af275f0416b3cb2914574bf51ec60d1c857020fbd34b5427c5faf"
  license "ISC"
  head "https://github.com/kevinlawler/kona.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:Win(?:64)?[._-])?v?(\d+(?:\.\d+)*)[^"' >]*["' >]}i)
  end

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kona"
    sha256 cellar: :any_skip_relocation, mojave: "b8681599c7062e0170204122caae4859377aa1827149920eb1afc85c2e722513"
  end

  def install
    system "make"
    bin.install "k"
  end

  test do
    assert_match "Hello, world!", pipe_output("#{bin}/k", '`0: "Hello, world!"')
  end
end
