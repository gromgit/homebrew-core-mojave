class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.29.0.tar.gz"
  sha256 "f9eed6fdf6f0e436b481d9f882461bd9e0aed78bdbf77a61b99a9cf66875e549"
  license "Apache-2.0"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lean-cli"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "d6146bfe9e6cb48380fbec7d97b41e536ffb84cac388932337d6a9b41fd848ba"
  end

  depends_on "go" => :build

  def install
    build_from = build.head? ? "homebrew-head" : "homebrew"
    system "go", "build",
            "-ldflags", "-s -w -X main.pkgType=#{build_from}",
            *std_go_args,
            "-o", bin/"lean",
            "./lean"

    bash_completion.install "misc/lean-bash-completion" => "lean"
    zsh_completion.install "misc/lean-zsh-completion" => "_lean"
  end

  test do
    assert_match "lean version #{version}", shell_output("#{bin}/lean --version")
    assert_match "Please log in first.", shell_output("#{bin}/lean init 2>&1", 1)
  end
end
