class Toast < Formula
  desc "Tool for running tasks in containers"
  homepage "https://github.com/stepchowfun/toast"
  url "https://github.com/stepchowfun/toast/archive/v0.45.3.tar.gz"
  sha256 "0c6d1e7ecf0de3ed0647fcae040c8dd318a62604f22fb011301c2d3b69c2d439"
  license "MIT"
  head "https://github.com/stepchowfun/toast.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/toast"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "31afa8acbdf49ee93804544b7153698ede9c665e529bea0c0dd5b20123b01e25"
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
