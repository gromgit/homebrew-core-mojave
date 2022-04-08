class Zenith < Formula
  desc "In terminal graphical metrics for your *nix system"
  homepage "https://github.com/bvaisvil/zenith/"
  url "https://github.com/bvaisvil/zenith/archive/0.13.0.tar.gz"
  sha256 "e3f914e5effb842f5931b5b8310e05e90a40f6aff7384b54a9f18a73ba567032"
  license "MIT"
  version_scheme 1
  head "https://github.com/bvaisvil/zenith.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/zenith"
    sha256 cellar: :any_skip_relocation, mojave: "4aee178d1cf6e2390f4c28814df95284953c868e296308827e8c8bd841ba4de6"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "io/console"

    (testpath/"zenith").mkdir
    cmd = "#{bin}/zenith --db zenith"
    cmd += " | tee #{testpath}/out.log" unless OS.mac? # output not showing on PTY IO
    r, w, pid = PTY.spawn cmd
    r.winsize = [80, 43]
    sleep 1
    w.write "q"
    output = OS.mac? ? r.read : (testpath/"out.log").read
    assert_match(/PID\s+USER\s+P\s+N\s+↓CPU%\s+MEM%/, output.gsub(/\e\[[;\d]*m/, ""))
  ensure
    Process.kill("TERM", pid)
  end
end
