class Twty < Formula
  desc "Command-line twitter client written in golang"
  homepage "https://mattn.kaoriya.net/"
  url "https://github.com/mattn/twty/archive/refs/tags/v0.0.11.tar.gz"
  sha256 "d1ee544ff31a9a9488ff759da587baf927ab7c31b191b4b5bc010f36ecfb8188"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/twty"
    rebuild 3
    sha256 cellar: :any_skip_relocation, mojave: "9387335a08f8d9f448c54b0bdc34534af9072bc1c383596e13598fbc92d8b5d7"
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
