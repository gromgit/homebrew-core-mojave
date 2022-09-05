class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/v0.8.2.tar.gz"
  sha256 "890972fbf1a7f0a336c0f20e1e9ecc756c62d3debd75d22b596af993a3d8af01"
  license "Apache-2.0"
  revision 1
  head "https://github.com/bootandy/dust.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dust"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "0316a870f02832794cedc1406996d24cfb9acc9a81b428800a88cf1203890530"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/dust.bash"
    fish_completion.install "completions/dust.fish"
    zsh_completion.install "completions/_dust"
  end

  test do
    assert_match(/\d+.+?\./, shell_output("#{bin}/dust -n 1"))
  end
end
