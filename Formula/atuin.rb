class Atuin < Formula
  desc "Improved shell history for zsh and bash"
  homepage "https://github.com/ellie/atuin"
  url "https://github.com/ellie/atuin/archive/refs/tags/v11.0.0.tar.gz"
  sha256 "29689906e3fd6bc680c60c3b2f41f756da5bd677a4f4aea3d26eff87f5bebac4"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/atuin"
    sha256 cellar: :any_skip_relocation, mojave: "7fee38ca6dc9e649abfcaf6c6c3474db5ea3da2c36c4acfc84ca39d3642e0950"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # or `atuin init zsh` to setup the `ATUIN_SESSION`
    ENV["ATUIN_SESSION"] = "random"
    assert_match "autoload -U add-zsh-hook", shell_output("atuin init zsh")
    assert shell_output("atuin history list").blank?
  end
end
