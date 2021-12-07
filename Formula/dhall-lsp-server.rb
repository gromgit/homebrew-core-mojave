class DhallLspServer < Formula
  desc "Language Server Protocol (LSP) server for Dhall"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-lsp-server"
  url "https://hackage.haskell.org/package/dhall-lsp-server-1.0.17/dhall-lsp-server-1.0.17.tar.gz"
  sha256 "88433b4334d75c625d76b61859359b31e173531f11bb858ea4776eed46949c40"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dhall-lsp-server"
    sha256 cellar: :any_skip_relocation, mojave: "7e6a7b3f772b0a0a23bcbc35de162dd68e231dc4ccc1ee7f94676b3d345bc05c"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    input =
      "Content-Length: 152\r\n" \
      "\r\n" \
      "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"initialize\",\"params\":{\"" \
      "processId\":88075,\"rootUri\":null,\"capabilities\":{},\"trace\":\"ver" \
      "bose\",\"workspaceFolders\":null}}\r\n"

    output = pipe_output("#{bin}/dhall-lsp-server", input, 0)

    assert_match(/^Content-Length: \d+/i, output)
    assert_match "dhall.server.lint", output
  end
end
