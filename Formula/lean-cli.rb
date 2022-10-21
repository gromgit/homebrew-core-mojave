class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v1.0.2.tar.gz"
  sha256 "4d844ee3a216da8c2aa720adb936d8364280439f9839f8cd6eca59d91321f742"
  license "Apache-2.0"
  head "https://github.com/leancloud/lean-cli.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lean-cli"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "95f53de35c0f2fa1e450557f5058f865d9b9cf7f3b32c3699fd9a762b79727cf"
  end

  depends_on "go" => :build

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
