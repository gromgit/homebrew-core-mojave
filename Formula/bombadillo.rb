class Bombadillo < Formula
  desc "Non-web browser, designed for a growing list of protocols"
  homepage "https://bombadillo.colorfield.space/"
  url "https://tildegit.org/sloum/bombadillo/archive/2.4.0.tar.gz"
  sha256 "e0daed1d9d0fe7cbea52bc3e6ecff327749b54e792774e6b985e0d64b7a36437"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bombadillo"
    sha256 cellar: :any_skip_relocation, mojave: "45ed16323302c2f0662bcd2de5b674c405068eb8037804b5e6dafba49e896419"
  end

  depends_on "go" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    require "pty"
    require "io/console"

    cmd = "#{bin}/bombadillo gopher://bombadillo.colorfield.space"
    r, w, pid = PTY.spawn({ "XDG_CONFIG_HOME" => testpath/".config" }, cmd)
    r.winsize = [80, 43]
    sleep 1
    w.write "q"
    output = ""
    begin
      r.each_line { |line| output += line }
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
    assert_match "Bombadillo is a non-web browser", output

    status = PTY.check(pid)
    refute_nil status
    assert status.success?
  end
end
