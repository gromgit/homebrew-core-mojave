class Atuin < Formula
  desc "Improved shell history for zsh and bash"
  homepage "https://github.com/ellie/atuin"
  url "https://github.com/ellie/atuin/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "e8618a56791a22f4ab93d61bd15e28a6983583769f97a3ee3dc1329729f2921f"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/atuin"
    sha256 cellar: :any_skip_relocation, mojave: "4c414cb81c0d7bfab582d65e453de376b3639a9e60ec01b8cdbb53b3e0936348"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "autoload -U add-zsh-hook", shell_output("atuin init zsh")
    assert shell_output("atuin history list").blank?
  end
end
