class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/v0.33.2.tar.gz"
  sha256 "18a71b1c32f7891bbd8a1668686f0505d95d83537e9bf4cdffa2d257d924b08a"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/conftest"
    sha256 cellar: :any_skip_relocation, mojave: "d7b00c6c0f1b96a8928dda69cecafe55ceb5863850d179ff5dacab15c6af6c73"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/open-policy-agent/conftest/internal/commands.version=#{version}")

    bash_output = Utils.safe_popen_read(bin/"conftest", "completion", "bash")
    (bash_completion/"conftest").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"conftest", "completion", "zsh")
    (zsh_completion/"_conftest").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"conftest", "completion", "fish")
    (fish_completion/"conftest.fish").write fish_output
  end

  test do
    assert_match "Test your configuration files using Open Policy Agent", shell_output("#{bin}/conftest --help")

    # Using the policy parameter changes the default location to look for policies.
    # If no policies are found, a non-zero status code is returned.
    (testpath/"test.rego").write("package main")
    system "#{bin}/conftest", "verify", "-p", "test.rego"
  end
end
