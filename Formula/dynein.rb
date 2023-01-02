class Dynein < Formula
  desc "DynamoDB CLI"
  homepage "https://github.com/awslabs/dynein"
  url "https://github.com/awslabs/dynein/archive/v0.2.1.tar.gz"
  sha256 "1946d521b74da303bafd19a0a36fd7510a9f8c9fc5cf64d2e6742b4b0b2c9389"
  license "Apache-2.0"
  head "https://github.com/awslabs/dynein.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dynein"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "8b847392ca8dff31ae2ffdde1d64a9a817a39e02ff759c49466373c3b11e68bd"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3" # need to build `openssl-sys`
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "To find all tables in all regions", shell_output("#{bin}/dy desc 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/dy --version")
  end
end
