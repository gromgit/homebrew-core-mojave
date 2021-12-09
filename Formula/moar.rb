class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.8.4.tar.gz"
  sha256 "00fe9ae0631d89bce109ac5b8fb3f5ed0e090df1a5fe9e26cc54fa21f0e40710"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/moar"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "ef861f2274cb5580b338c75fc3c83fee16c1dad144014ca488ae3e6292a4716e"
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
