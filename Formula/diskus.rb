class Diskus < Formula
  desc "Minimal, fast alternative to 'du -sh'"
  homepage "https://github.com/sharkdp/diskus"
  url "https://github.com/sharkdp/diskus/archive/v0.7.0.tar.gz"
  sha256 "64b1b2e397ef4de81ea20274f98ec418b0fe19b025860e33beaba5494d3b8bd1"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/diskus"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "932f49cfe8dde884aa2cc8c81810b325f322d8c054b958fc82e7ce71ac94ce5a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.txt").write("Hello World")
    output = shell_output("#{bin}/diskus #{testpath}/test.txt")
    assert_match "4096", output
  end
end
