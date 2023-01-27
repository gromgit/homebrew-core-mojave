class Busted < Formula
  desc "Elegant Lua unit testing"
  homepage "https://lunarmodules.github.io/busted/"
  url "https://github.com/lunarmodules/busted/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "5b75200fd6e1933a2233b94b4b0b56a2884bf547d526cceb24741738c0443b47"
  license "MIT"
  head "https://github.com/lunarmodules/busted.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/busted"
    sha256 cellar: :any_skip_relocation, mojave: "872d3761cfc521455805e724ab2523d002cf48531c41c67caf8ee6783eebd5fe"
  end

  depends_on "luarocks" => :build
  depends_on "lua"

  uses_from_macos "unzip" => :build

  def install
    system "luarocks", "make", "--tree=#{libexec}", "--global", "--lua-dir=#{Formula["lua"].opt_prefix}"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    test_file = testpath/"test.lua"

    test_file.write <<~EOS
      describe("brewtest", function()
        it("should pass", function()
          assert.is_true(true)
        end)
      end)
    EOS

    assert_match "1 success / 0 failures", shell_output("#{bin}/busted #{test_file}")

    assert_match version.to_s, shell_output("#{bin}/busted --version")
  end
end
