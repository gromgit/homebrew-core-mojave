class ValaLanguageServer < Formula
  desc "Code Intelligence for Vala & Genie"
  homepage "https://github.com/vala-lang/vala-language-server"
  url "https://github.com/vala-lang/vala-language-server/releases/download/0.48.4/vala-language-server-0.48.4.tar.xz"
  sha256 "0fd65b641a4bd6e0385502f0536f803bf542fd8bae6a2adb04e2e299ccca4551"
  license "LGPL-2.1-only"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/vala-language-server"
    rebuild 1
    sha256 cellar: :any, mojave: "856588ed80ca0a458fbdee1359f9faa486b2f6b9fffb1de47a44b4cc00b5bcd0"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "json-glib"
  depends_on "jsonrpc-glib"
  depends_on "libgee"
  depends_on "vala"

  def install
    system "meson", "-Dplugins=false", "build", *std_meson_args
    system "ninja", "-C", "build"
    system "ninja", "-C", "build", "install"
  end

  test do
    length = (151 + testpath.to_s.length)
    input =
      "Content-Length: #{length}\r\n" \
      "\r\n" \
      "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"initialize\",\"params\":{\"" \
      "processId\":88075,\"rootPath\":\"#{testpath}\",\"capabilities\":{},\"trace\":\"ver" \
      "bose\",\"workspaceFolders\":null}}\r\n"
    output = pipe_output("#{bin}/vala-language-server", input, 0)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
