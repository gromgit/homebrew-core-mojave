class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.42.2.tar.gz"
  sha256 "f96ca3c985c50c2c393d0c914a9ec22f7ed4a21f1948094b8161319ca63b1625"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/opa"
    sha256 cellar: :any_skip_relocation, mojave: "ad975c1cf67763eaaf715bbbef7e619adcec2937780d3c11bb99c32ef38b7ffd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args,
              "-ldflags", "-X github.com/open-policy-agent/opa/version.Version=#{version}"
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    bash_output = Utils.safe_popen_read(bin/"opa", "completion", "bash")
    (bash_completion/"opa").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"opa", "completion", "zsh")
    (zsh_completion/"_opa").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"opa", "completion", "fish")
    (fish_completion/"opa.fish").write fish_output
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
