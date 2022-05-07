class Statix < Formula
  desc "Lints and suggestions for the nix programming language"
  homepage "https://github.com/nerdypepper/statix"
  url "https://github.com/nerdypepper/statix/archive/v0.5.5.tar.gz"
  sha256 "d21dae937808133545bb74009e9cec5ffc3623b66638e427ffcd195e40c7c2c4"
  license "MIT"
  head "https://github.com/nerdypepper/statix.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/statix"
    sha256 cellar: :any_skip_relocation, mojave: "e343ee61d8166e9dbe442a1ca89d39f84bd0ee9ecdc11c1418051dd71423118e"
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
