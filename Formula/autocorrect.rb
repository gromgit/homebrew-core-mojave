class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://github.com/huacnlee/autocorrect"
  url "https://github.com/huacnlee/autocorrect/archive/v2.5.4.tar.gz"
  sha256 "6d06ad99f99aad35400a8cb5bad72eac1496b09953aaa481205ce701a6a3c56d"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/autocorrect"
    sha256 cellar: :any_skip_relocation, mojave: "82f7e88fe5c43939a91a0928340fa967d64076f6c9b20659bf8d5de3e11d0d1b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "autocorrect-cli")
  end

  test do
    (testpath/"autocorrect.md").write "Hello世界"
    out = shell_output("#{bin}/autocorrect autocorrect.md").chomp
    assert_equal "Hello 世界", out
  end
end
