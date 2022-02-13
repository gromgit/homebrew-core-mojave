class Toast < Formula
  desc "Tool for running tasks in containers"
  homepage "https://github.com/stepchowfun/toast"
  url "https://github.com/stepchowfun/toast/archive/v0.45.3.tar.gz"
  sha256 "0c6d1e7ecf0de3ed0647fcae040c8dd318a62604f22fb011301c2d3b69c2d439"
  license "MIT"
  head "https://github.com/stepchowfun/toast.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/toast"
    sha256 cellar: :any_skip_relocation, mojave: "cca2f3ee2e0b1144617e20949742dbb0f2d2b90dfd435a5df69a1558bdb3daff"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"toast.yml").write <<~EOS
      image: alpine
      tasks:
        homebrew_test:
          description: brewtest
          command: echo hello
    EOS

    assert_match "homebrew_test", shell_output("#{bin}/toast --list")
  end
end
