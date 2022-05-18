class Feroxbuster < Formula
  desc "Fast, simple, recursive content discovery tool written in Rust"
  homepage "https://epi052.github.io/feroxbuster"
  url "https://github.com/epi052/feroxbuster/archive/refs/tags/2.7.1.tar.gz"
  sha256 "4fc37897d98bb09bfe738067eb5889adff20e0caef70e4487d20f41ec920381b"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/feroxbuster"
    sha256 cellar: :any_skip_relocation, mojave: "5664b56e25d39cf86278526ec316654a3865a3110b29e315be339b08cdb946ef"
  end

  depends_on "rust" => :build
  depends_on "miniserve" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"wordlist").write <<~EOS
      a.txt
      b.txt
    EOS

    (testpath/"web").mkpath
    (testpath/"web/a.txt").write "a"
    (testpath/"web/b.txt").write "b"

    port = free_port
    pid = fork do
      exec "miniserve", testpath/"web", "-i", "127.0.0.1", "--port", port.to_s
    end

    sleep 1

    begin
      exec bin/"feroxbuster", "-q", "-w", testpath/"wordlist", "-u", "http://127.0.0.1:#{port}"
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
