class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.17.2.tar.gz"
  sha256 "92f3688abf192d726a85f92293ef7a92dda4da638f1f462a8d1153ebc27a045b"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/xplr"
    sha256 cellar: :any_skip_relocation, mojave: "1b62d0bca85b66224996236a1da46155227a4737834585abea250912bc84a456"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input, = Open3.popen2 "SHELL=/bin/sh script -q output.txt"
    input.puts "stty rows 80 cols 130"
    input.puts bin/"xplr"
    input.putc "q"
    input.puts "exit"

    sleep 5
    File.open(testpath/"output.txt", "r:ISO-8859-7") do |f|
      contents = f.read
      assert_match testpath.to_s, contents
    end
  end
end
