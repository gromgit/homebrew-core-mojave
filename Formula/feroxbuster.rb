class Feroxbuster < Formula
  desc "Fast, simple, recursive content discovery tool written in Rust"
  homepage "https://epi052.github.io/feroxbuster"
  url "https://github.com/epi052/feroxbuster/archive/v2.6.2.tar.gz"
  sha256 "562095ad5bb7c72aea3e901891bcfa675609833d802cf68b2cbb43e1bd64b853"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/feroxbuster"
    sha256 cellar: :any_skip_relocation, mojave: "ce925d027b1f9197b324f43cd2aac4c5e5bdec678cffe25487d6c254c374358a"
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
