class Yank < Formula
  desc "Copy terminal output to clipboard"
  homepage "https://github.com/mptre/yank"
  url "https://github.com/mptre/yank/archive/v1.3.0.tar.gz"
  sha256 "40f5472df5f6356a4d6f48862a19091bd4de3f802b3444891b3bc4b710fb35ca"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/yank"
    sha256 cellar: :any_skip_relocation, mojave: "6960130f5546c3db0973c3fe8c7bcee5c971e9427d5cf30436d1afc8a2718c97"
  end

  uses_from_macos "expect" => :test

  def install
    system "make", "install", "PREFIX=#{prefix}", "YANKCMD=pbcopy"
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn sh
      set timeout 1
      send "echo key=value | #{bin}/yank -d = | cat"
      send "\r"
      send "\016"
      send "\r"
      expect {
            "value" { send "exit\r"; exit 0 }
            timeout { send "exit\r"; exit 1 }
      }
    EOS
    system "expect", "-f", "test.exp"
  end
end
