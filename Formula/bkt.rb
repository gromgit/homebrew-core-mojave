class Bkt < Formula
  desc "Utility for caching the results of shell commands"
  homepage "https://www.bkt.rs"
  url "https://github.com/dimo414/bkt/archive/refs/tags/0.5.2.tar.gz"
  sha256 "e6acab9ae6a617fe471dceed9f69064e1f0cb3a8eb93d82e2087faeab4d48ee8"
  license "MIT"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bkt"
    sha256 cellar: :any_skip_relocation, mojave: "1e21392188bd47f98984733d8d85c46f4851c95092903229c8c14c00fe4781d8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Make sure date output is cached between runs
    output1 = shell_output("#{bin}/bkt -- date +%s.%N")
    sleep(1)
    assert_equal output1, shell_output("#{bin}/bkt -- date +%s.%N")
  end
end
