class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "2.5.3",
      revision: "dc5ee0b01a9610389e275ed8ff0746ba78cdd367"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lua-language-server"
    sha256 cellar: :any_skip_relocation, mojave: "3814525054dc7c8667515620c8fe7eca39648afef16c6f1f5997a36cd3e2b5f4"
  end

  depends_on "ninja" => :build

  on_linux do
    depends_on "gcc" # For C++17
  end

  fails_with gcc: 5

  def install
    ENV.cxx11

    # Disable `filesystem.test_appdata_path`.
    # This test expects to find user cache directories under ${HOME},
    # which is not compatible with homebrew's build environment.
    # See https://github.com/actboy168/bee.lua/issues/21
    inreplace buildpath.glob("**/3rd/bee.lua/test/test_filesystem.lua"),
              "test_fs:test_appdata_path()",
              "\\0 do return end"

    chdir "3rd/luamake" do
      system "compile/install.sh"
    end
    system "3rd/luamake/luamake", "rebuild"

    bindir = if OS.mac?
      "bin/macOS"
    else
      "bin/Linux"
    end
    (libexec/bindir).install "#{bindir}/lua-language-server", "#{bindir}/main.lua"
    libexec.install "main.lua", "debugger.lua", "locale", "meta", "script"
    bin.write_exec_script libexec/bindir/"lua-language-server"
    (libexec/"log").mkpath
  end

  test do
    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output("#{bin}/lua-language-server", 0)
  end
end
