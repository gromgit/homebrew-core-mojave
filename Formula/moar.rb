class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.8.4.tar.gz"
  sha256 "00fe9ae0631d89bce109ac5b8fb3f5ed0e090df1a5fe9e26cc54fa21f0e40710"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/moar"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "0df7172b13093d6537f06b2ef89c2815152c8ecad951eea917e97c66546ed0a9"
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
