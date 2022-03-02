class Doubledown < Formula
  desc "Sync local changes to a remote directory"
  homepage "https://github.com/devstructure/doubledown"
  url "https://github.com/devstructure/doubledown/archive/v0.0.2.tar.gz"
  sha256 "47ff56b6197c5302a29ae4a373663229d3b396fd54d132adbf9f499172caeb71"
  license "BSD-2-Clause"
  head "https://github.com/devstructure/doubledown.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/doubledown"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "1064ac05c9bfcf12e9b16120fef190e074863c78449028fa46b9ef324d5609bf"
  end


  def install
    bin.install Dir["bin/*"]
    man1.install Dir["man/man1/*.1"]
  end

  test do
    system "#{bin}/doubledown", "--help"
  end
end
