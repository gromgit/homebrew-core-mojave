class Kalker < Formula
  desc "Full-featured calculator with math syntax"
  homepage "https://kalker.strct.net"
  url "https://github.com/PaddiM8/kalker/archive/v1.1.0.tar.gz"
  sha256 "4332563b18e1c2c8c54871e46f40e55791d3f86612d4651c69b690827051a484"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kalker"
    sha256 cellar: :any_skip_relocation, mojave: "1359f25c450e8ebb4f911e9c73a7993ed7caebd70661cd7aa9412ed07e40a621"
  end

  depends_on "rust" => :build

  uses_from_macos "m4" => :build

  def install
    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_equal shell_output("#{bin}/kalker 'sum(1, 3, 2n+1)'").chomp, "15"
  end
end
