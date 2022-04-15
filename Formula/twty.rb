class Twty < Formula
  desc "Command-line twitter client written in golang"
  homepage "https://mattn.kaoriya.net/"
  url "https://github.com/mattn/twty/archive/refs/tags/v0.0.13.tar.gz"
  sha256 "4e76ada5e7c5f2e20881fbf303fb50d3d4a443a8e37f2444371a90102737e49b"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/twty"
    sha256 cellar: :any_skip_relocation, mojave: "88a204abdc6b91f39fad5342d860ec3e2faba7455ad898293b2ed502a91ab5fa"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # Prevent twty executing open or xdg-open
    testpath_bin = testpath/"bin"
    ENV.prepend_path "PATH", testpath_bin
    testpath_bin.install_symlink which("true") => "open"
    testpath_bin.install_symlink which("true") => "xdg-open"

    # twty requires PIN code from stdin and putting nothing to stdin to make authentication failed
    require "pty"
    PTY.spawn(bin/"twty") do |r, w, _pid|
      assert_match "Open this URL and enter PIN.", r.gets
      assert_match "https://api.twitter.com/oauth/authenticate?oauth_token=", r.gets
      w.puts
      sleep 1 # Wait for twty exitting
    end
  end
end
