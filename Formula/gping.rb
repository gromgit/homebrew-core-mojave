class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://github.com/orf/gping/archive/gping-v1.2.7.tar.gz"
  sha256 "c45ae91f5a88eeb4f4fe0d5c2fbe0e318e3e6329645523a1c7aa0e7c6166cb15"
  license "MIT"
  head "https://github.com/orf/gping.git", branch: "master"

  # The GitHub repository has a "latest" release but it can sometimes point to
  # a release like `v1.2.3-post`, `v1.2.3-post2`, etc. We're checking the Git
  # tags because the author of `gping` requested that we omit `post` releases:
  # https://github.com/Homebrew/homebrew-core/pull/66366#discussion_r537339032
  livecheck do
    url :stable
    regex(/^gping[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gping"
    sha256 cellar: :any_skip_relocation, mojave: "526194fc9c8dccbf4888e544f7453c283247e8ffe9005241698f42843dada053"
  end

  depends_on "rust" => :build

  def install
    cd "gping" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    require "pty"
    require "io/console"

    r, w, pid = PTY.spawn("#{bin}/gping google.com")
    r.winsize = [80, 130]
    sleep 1
    w.write "q"

    screenlog = r.read
    # remove ANSI colors
    screenlog.encode!("UTF-8", "binary",
      invalid: :replace,
      undef:   :replace,
      replace: "")
    screenlog.gsub!(/\e\[([;\d]+)?m/, "")

    assert_match "google.com (", screenlog
  ensure
    Process.kill("TERM", pid)
  end
end
