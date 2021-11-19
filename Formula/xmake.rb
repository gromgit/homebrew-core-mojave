class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.5.9/xmake-v2.5.9.tar.gz"
  sha256 "5b50e3f28956cabcaa153624c91781730387ceb7c056f3f9b5306b1c77460d8f"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/xmake"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "0f11403aa050abf1f14471bd8283b9c5e1e08af91eaa2867cbfb168a99e0a6ee"
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
    on_linux do
      ENV["XMAKE_ROOT"] = "y" if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end
    system bin/"xmake", "create", "test"
    cd "test" do
      system bin/"xmake"
      assert_equal "hello world!", shell_output("#{bin}/xmake run").chomp
    end
  end
end
