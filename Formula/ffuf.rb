class Ffuf < Formula
  desc "Fast web fuzzer written in Go"
  homepage "https://github.com/ffuf/ffuf"
  url "https://github.com/ffuf/ffuf/archive/v1.5.0.tar.gz"
  sha256 "70dc411c014c826f9c8a7b021e01d5bc50e2cba17e0dcc4df3e2e2574ad12073"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ffuf"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "f30a4803d88e7e99c032d21dec96cd3462d02eccc07f146a79c67fe60217c7e7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"words.txt").write <<~EOS
      dog
      cat
      horse
      snake
      ape
    EOS

    output = shell_output("#{bin}/ffuf -u https://example.org/FUZZ -w words.txt 2>&1")
    assert_match %r{:: Progress: \[5/5\].*Errors: 0 ::$}, output
  end
end
