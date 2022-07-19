class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v1.0.1.tar.gz"
  sha256 "d1cd31c4942a1d321ce6c608973f32f513df892b1441930169bc825149f77e98"
  license "Apache-2.0"
  head "https://github.com/leancloud/lean-cli.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lean-cli"
    sha256 cellar: :any_skip_relocation, mojave: "8f9702584eeb6c8b4eee5570834c5ad518c49736d44edd4b2f5ac3c713a3866b"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    build_from = build.head? ? "homebrew-head" : "homebrew"
    system "go", "build", *std_go_args(output: bin/"lean", ldflags: "-s -w -X main.pkgType=#{build_from}"), "./lean"

    bin.install_symlink "lean" => "tds"

    bash_completion.install "misc/lean-bash-completion" => "lean"
    zsh_completion.install "misc/lean-zsh-completion" => "_lean"
  end

  test do
    assert_match "lean version #{version}", shell_output("#{bin}/lean --version")
    assert_match "Invalid access token.", shell_output("#{bin}/lean login --region us-w1 --token foobar 2>&1", 1)
  end
end
