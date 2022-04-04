class Jrsonnet < Formula
  desc "Rust implementation of Jsonnet language"
  homepage "https://github.com/CertainLach/jrsonnet"
  url "https://github.com/CertainLach/jrsonnet/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "2396c57a49a20db99da17b8ddd1b0b283f1a6e7c5ae1dc94823e7503cbb6ce3f"
  license "MIT"
  head "https://github.com/CertainLach/jrsonnet.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jrsonnet"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "f058e04c0a989d1aa33197726c32da6775290722c05e4c28816cb83974fd37aa"
  end

  depends_on "rust" => :build

  def install
    cd "cmds/jrsonnet" do
      system "cargo", "install", *std_cargo_args
    end

    bash_output = Utils.safe_popen_read(bin/"jrsonnet", "--generate", "bash", "-")
    (bash_completion/"jrsonnet").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"jrsonnet", "--generate", "zsh", "-")
    (zsh_completion/"_jrsonnet").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"jrsonnet", "--generate", "fish", "-")
    (fish_completion/"jrsonnet.fish").write fish_output
  end

  test do
    assert_equal "2\n", shell_output("#{bin}/jrsonnet -e '({ x: 1, y: self.x } { x: 2 }).y'")
  end
end
