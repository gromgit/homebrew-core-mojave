class Toast < Formula
  desc "Tool for running tasks in containers"
  homepage "https://github.com/stepchowfun/toast"
  url "https://github.com/stepchowfun/toast/archive/v0.45.4.tar.gz"
  sha256 "b9b7198ccde0c2a999272ed8f0023125f03162f53b9bb0991d8b8e83a309c151"
  license "MIT"
  head "https://github.com/stepchowfun/toast.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/toast"
    sha256 cellar: :any_skip_relocation, mojave: "5cf9861e6ed6347ce5b4f8741d85d2b2dd18078b749b85b7ad0565af9f1b93bc"
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
