class Sgn < Formula
  desc "Shikata ga nai (仕方がない) encoder ported into go with several improvements"
  homepage "https://github.com/EgeBalci/sgn"
  url "https://github.com/EgeBalci/sgn/archive/refs/tags/2.0.tar.gz"
  sha256 "b894e4cb396a5bb118a4081db9c54938e4ca903f67a998e7de8ec2763f2fcf53"
  license "MIT"
  head "https://github.com/EgeBalci/sgn.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sgn"
    sha256 cellar: :any_skip_relocation, mojave: "66059cf98415b2b4f688ae726970888e4fceb066b0b4027df0fd52276cd91288"
  end

  depends_on "go" => :build
  depends_on "keystone" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match "All done ＼(＾O＾)／", shell_output("#{bin}/sgn -o #{testpath}/sgn.out #{test_fixtures("mach/a.out")}")
  end
end
