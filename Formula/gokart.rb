class Gokart < Formula
  desc "Static code analysis for securing Go code"
  homepage "https://github.com/praetorian-inc/gokart"
  url "https://github.com/praetorian-inc/gokart/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "81bf1e26531117de4da9b160ede80aa8f6c4d4984cc1d7dea398083b8e232eb7"
  license "Apache-2.0"
  head "https://github.com/praetorian-inc/gokart.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gokart"
    sha256 cellar: :any_skip_relocation, mojave: "fe21c55df3429ca876c8b7286d4e4ef5a43a5dd407f97f5ac0e9dde64b115d30"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    mkdir "brewtest" do
      system "go", "mod", "init", "brewtest"
      (testpath/"brewtest/main.go").write <<~EOS
        package main

        func main() {}
      EOS
    end

    assert_match "GoKart found 0 potentially vulnerable functions",
      shell_output("#{bin}/gokart scan brewtest")

    assert_match version.to_s, shell_output("#{bin}/gokart version")
  end
end
