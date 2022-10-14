class Ne < Formula
  desc "Text editor based on the POSIX standard"
  homepage "https://github.com/vigna/ne"
  url "https://github.com/vigna/ne/archive/3.3.2.tar.gz"
  sha256 "9b8b757db22bd8cb783cf063f514143a8c325e5c321af31901e0f76e77455417"
  license "GPL-3.0"
  head "https://github.com/vigna/ne.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ne"
    sha256 mojave: "0a498e30f766e68a743aa1f7d79dd36743f1c5b2ff02769a04b0b0c5d458b1a1"
  end

  depends_on "texinfo" => :build

  uses_from_macos "ncurses"

  on_linux do
    # The version of `env` in CI is too old, so we need to use brewed coreutils.
    depends_on "coreutils" => :build
  end

  def install
    # Use newer env on Linux that supports -S option.
    unless OS.mac?
      inreplace "version.pl",
                "/usr/bin/env",
                Formula["coreutils"].libexec/"gnubin/env"
    end
    ENV.deparallelize
    cd "src" do
      system "make"
    end
    system "make", "build", "PREFIX=#{prefix}", "install"
  end

  test do
    require "pty"

    ENV["TERM"] = "xterm"
    document = testpath/"test.txt"
    macros = testpath/"macros"
    document.write <<~EOS
      This is a test document.
    EOS
    macros.write <<~EOS
      GotoLine 2
      InsertString line 2
      InsertLine
      Exit
    EOS
    PTY.spawn(bin/"ne", "--macro", macros, document) do |_r, _w, pid|
      sleep 1
      Process.kill "KILL", pid
    end
    assert_equal <<~EOS, document.read
      This is a test document.
      line 2
    EOS
  end
end
