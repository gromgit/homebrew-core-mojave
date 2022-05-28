class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.9.4.tar.gz"
  sha256 "3073f3d086ec7a9980b2a9db6e3500233e99626c5c3deec21c3f149199d96b40"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/moar"
    sha256 cellar: :any_skip_relocation, mojave: "d62aa6c2b2d9af3c1a30099c2a00016c1c1d1188c62259cbb6944138ecb1b3cd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end
