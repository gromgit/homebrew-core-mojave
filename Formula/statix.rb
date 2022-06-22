class Statix < Formula
  desc "Lints and suggestions for the nix programming language"
  homepage "https://github.com/nerdypepper/statix"
  url "https://github.com/nerdypepper/statix/archive/v0.5.6.tar.gz"
  sha256 "ed4e05c96541372d917691797674bacc1759d6a1c2d621fef5db650dfa34aea7"
  license "MIT"
  head "https://github.com/nerdypepper/statix.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/statix"
    sha256 cellar: :any_skip_relocation, mojave: "3d54822197c90f2c70423fe828bd41e040d1da82bc2d635fcac0129e4e70a582"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "bin")
  end

  test do
    (testpath/"test.nix").write <<~EOS
      github:nerdypepper/statix
    EOS
    assert_match "Found unquoted URI expression", shell_output("#{bin}/statix check test.nix", 1)

    system bin/"statix", "fix", "test.nix"
    system bin/"statix", "check", "test.nix"

    assert_match version.to_s, shell_output("#{bin}/statix --version")
  end
end
