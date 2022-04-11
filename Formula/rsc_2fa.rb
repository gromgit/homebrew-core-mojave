class Rsc2fa < Formula
  desc "Two-factor authentication on the command-line"
  homepage "https://pkg.go.dev/rsc.io/2fa"
  url "https://github.com/rsc/2fa/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "d8db6b9a714c9146a4b82fd65b54f9bdda3e58380bce393f45e1ef49e4e9bee5"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f832afe87766e2847eadb453848ebf881c0c60bb608a71640b6c237ec44b9069"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6db5849c61249766bb9ac2168f2570c87b0893e19c7600e9749f375c6934ffa5"
    sha256 cellar: :any_skip_relocation, monterey:       "aaf3afec742c3a53fd5a78e6677750b90120bc7803ac93c004d4f337d285a605"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c0d499b3ee3fa0a1d2934e05fd36cdcf75f10710ec3fdc9192d07f74074262b"
    sha256 cellar: :any_skip_relocation, catalina:       "7c0d499b3ee3fa0a1d2934e05fd36cdcf75f10710ec3fdc9192d07f74074262b"
    sha256 cellar: :any_skip_relocation, mojave:         "7c0d499b3ee3fa0a1d2934e05fd36cdcf75f10710ec3fdc9192d07f74074262b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71c943ce568138c782321aaa436adf79d194707bd140f82b50046aff80851e3c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-mod=mod", "-o", bin/"2fa"
  end

  test do
    out = shell_output("#{bin}/2fa -help 2>&1", 2)
    assert_match(/^usage:/, out)

    out = shell_output("echo AAAAAAAAAAAAAAAA | #{bin}/2fa -add example 2>&1")
    assert_match(/^2fa key for example:/, out)

    out = shell_output("#{bin}/2fa example")
    assert_match(/^[0-9]{6}\n$/, out)
  end
end
