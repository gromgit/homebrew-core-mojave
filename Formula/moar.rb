class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "17e527fc18ff25c590ff8790c32322e9c9c5e036ccf279ca2ed63be870889182"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/moar"
    sha256 cellar: :any_skip_relocation, mojave: "7d4108c488ed2b8e281e843579c0f74f47edc5c767f3335e39bc55e6dccf5fb5"
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
