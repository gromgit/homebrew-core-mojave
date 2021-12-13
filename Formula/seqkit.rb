class Seqkit < Formula
  desc "Cross-platform and ultrafast toolkit for FASTA/Q file manipulation in Golang"
  homepage "https://bioinf.shenwei.me/seqkit"
  url "https://github.com/shenwei356/seqkit/archive/v2.1.0.tar.gz"
  sha256 "99041d8c56e7a5e346e852cc8061cf828ee14b5f550b2f263e6031e99491c536"
  license "MIT"
  head "https://github.com/shenwei356/seqkit.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/seqkit"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "fd57a18eed8a4d45a814988233b8755814791d2b4c1fb19eb239474e0344a86b"
  end

  depends_on "go" => :build

  resource "testdata" do
    url "https://raw.githubusercontent.com/shenwei356/seqkit/e37d70a7e0ca0e53d6dbd576bd70decac32aba64/tests/seqs4amplicon.fa"
    sha256 "b0f09da63e3c677cc698d5cdff60e2d246368263c22385937169a9a4c321178a"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./seqkit"
  end

  test do
    resource("testdata").stage do
      assert_equal ">seq1\nCCCACTGAAA",
      shell_output("#{bin}/seqkit amplicon --quiet -F CCC -R TTT seqs4amplicon.fa").strip
    end
  end
end
