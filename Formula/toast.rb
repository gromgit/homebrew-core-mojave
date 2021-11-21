class Toast < Formula
  desc "Tool for running tasks in containers"
  homepage "https://github.com/stepchowfun/toast"
  url "https://github.com/stepchowfun/toast/archive/v0.45.2.tar.gz"
  sha256 "9d1a4c785f62f68effa362c39eab1e0802fd40402416e8938ea7a7d4088945d0"
  license "MIT"
  head "https://github.com/stepchowfun/toast.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/toast"
    sha256 cellar: :any_skip_relocation, mojave: "6d2cf710d1d7ef1e334df73beba321d37eeb24e9c14baf7dd592f5b215e906b2"
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
