class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.6.9/xmake-v2.6.9.tar.gz"
  sha256 "68f2e7ef85db2841c707bb909ae4a5d058e8c1e4837c2a95b0bfefd56600ca83"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/xmake"
    sha256 cellar: :any_skip_relocation, mojave: "8801d2f3dea3274a1a3187ec1e1a80fc6b12d9615a66c6916d54b1667e3015a1"
  end

  on_linux do
    depends_on "readline"
  end

  def install
    ENV["XMAKE_ROOT"] = "y" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    ENV["XMAKE_ROOT"] = "y" if OS.linux? && (ENV["HOMEBREW_GITHUB_ACTIONS"])
    system bin/"xmake", "create", "test"
    cd "test" do
      system bin/"xmake"
      assert_equal "hello world!", shell_output("#{bin}/xmake run").chomp
    end
  end
end
