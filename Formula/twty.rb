class Twty < Formula
  desc "Command-line twitter client written in golang"
  homepage "https://github.com/mattn/twty/"
  url "https://github.com/mattn/twty/archive/refs/tags/v0.0.13.tar.gz"
  sha256 "4e76ada5e7c5f2e20881fbf303fb50d3d4a443a8e37f2444371a90102737e49b"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/twty"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "1c684da854c8d6f826c19cb695d1ddc4a0fae9a201897294983bb70969ba6451"
  end

  depends_on "go" => :build

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
