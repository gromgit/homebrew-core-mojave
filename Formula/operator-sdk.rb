class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.22.1",
      revision: "46ab175459a775d2fb9f0454d0b4a8850dd745ed"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/operator-sdk"
    sha256 cellar: :any_skip_relocation, mojave: "32f30bc39063338ad3ba840f25cef79606430eea3436d02ba86f51ae04ac53ea"
  end

  depends_on "go"

  def install
    ENV["GOBIN"] = libexec/"bin"
    system "make", "install"

    # Install bash completion
    output = Utils.safe_popen_read(libexec/"bin/operator-sdk", "completion", "bash")
    (bash_completion/"operator-sdk").write output

    # Install zsh completion
    output = Utils.safe_popen_read(libexec/"bin/operator-sdk", "completion", "zsh")
    (zsh_completion/"_operator-sdk").write output

    # Install fish completion
    output = Utils.safe_popen_read(libexec/"bin/operator-sdk", "completion", "fish")
    (fish_completion/"operator-sdk.fish").write output

    output = libexec/"bin/operator-sdk"
    (bin/"operator-sdk").write_env_script(output, PATH: "$PATH:#{Formula["go@1.17"].opt_bin}")
  end

  test do
    if build.stable?
      version_output = shell_output("#{bin}/operator-sdk version")
      assert_match "version: \"v#{version}\"", version_output
      commit_regex = /[a-f0-9]{40}/
      assert_match commit_regex, version_output
    end

    mkdir "test" do
      output = shell_output("#{bin}/operator-sdk init --domain=example.com --repo=github.com/example/memcached")
      assert_match "$ operator-sdk create api", output

      output = shell_output("#{bin}/operator-sdk create api --group c --version v1 --kind M --resource --controller")
      assert_match "$ make manifests", output
    end
  end
end
