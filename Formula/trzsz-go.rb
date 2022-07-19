class TrzszGo < Formula
  desc "Simple file transfer tools, similar to lrzsz (rz/sz), and compatible with tmux"
  homepage "https://trzsz.github.io"
  url "https://github.com/trzsz/trzsz-go/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "f39c930360a36788f13f26da6792fcce09674e45beb539f0b4b4a747d17576ab"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/trzsz-go"
    sha256 cellar: :any_skip_relocation, mojave: "fbfe8389767f82296819bf4c19823a2ddc431726785d80811bd093a47186675a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"trz", "./cmd/trz"
    system "go", "build", "-o", bin/"tsz", "./cmd/tsz"
    system "go", "build", "-o", bin/"trzsz", "./cmd/trzsz"
  end

  test do
    assert_match "trzsz go #{version}", shell_output("#{bin}/trzsz --version")
    assert_match "trz (trzsz) go #{version}", shell_output("#{bin}/trz --version")
    assert_match "tsz (trzsz) go #{version}", shell_output("#{bin}/tsz --version")

    assert_match "executable file not found", shell_output("#{bin}/trzsz cmd_not_exists 2>&1", 255)
    touch "tmpfile"
    assert_match "Not a directory", shell_output("#{bin}/trz tmpfile 2>&1", 254)
    rm "tmpfile"
    assert_match "No such file", shell_output("#{bin}/tsz tmpfile 2>&1", 255)
  end
end
