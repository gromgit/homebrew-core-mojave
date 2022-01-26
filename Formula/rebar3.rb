class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.18.0.tar.gz"
  sha256 "cce1925d33240d81d0e4d2de2eef3616d4c17b0532ed004274f875e6607d25d2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rebar3"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "d1de4c7d0b2b66b7b77805fbefd0148e6a98513ebbd05ce5cd97eef2b7cd1efa"
  end

  depends_on "erlang"

  def install
    system "./bootstrap"
    bin.install "rebar3"

    bash_completion.install "priv/shell-completion/bash/rebar3"
    zsh_completion.install "priv/shell-completion/zsh/_rebar3"
    fish_completion.install "priv/shell-completion/fish/rebar3.fish"
  end

  test do
    system bin/"rebar3", "--version"
  end
end
