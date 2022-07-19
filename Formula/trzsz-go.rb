class TrzszGo < Formula
  desc "Simple file transfer tools, similar to lrzsz (rz/sz), and compatible with tmux"
  homepage "https://trzsz.github.io"
  url "https://github.com/trzsz/trzsz-go/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "a28f57ddab8e1a7b721584eb52116662bc3099562ac261d8f3191c2789eeec48"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/trzsz-go"
    sha256 cellar: :any_skip_relocation, mojave: "9f619af424aee779152a7ed1c577b1b3c46481b38ffb8ba0613346035e5a232c"
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
