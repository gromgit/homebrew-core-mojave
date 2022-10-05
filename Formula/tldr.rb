class Tldr < Formula
  desc "Simplified and community-driven man pages"
  homepage "https://tldr.sh/"
  url "https://github.com/tldr-pages/tldr-c-client/archive/v1.5.0.tar.gz"
  sha256 "8e3f0c3f471896f8cfadbf9000aa8f2eff61fc3d76e25203ddc7640331c2a2af"
  license "MIT"
  head "https://github.com/tldr-pages/tldr-c-client.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tldr"
    rebuild 1
    sha256 cellar: :any, mojave: "503237bc9aa8b3cfb791169714bdf3b935a36713958993d0fc464575838ecd80"
  end

  depends_on "pkg-config" => :build
  depends_on "libzip"

  uses_from_macos "curl"

  conflicts_with "tealdeer", because: "both install `tldr` binaries"

  def install
    system "make", "PREFIX=#{prefix}", "install"

    bash_completion.install "autocomplete/complete.bash" => "tldr"
    zsh_completion.install "autocomplete/complete.zsh" => "_tldr"
    fish_completion.install "autocomplete/complete.fish" => "tldr.fish"
  end

  test do
    assert_match "brew", shell_output("#{bin}/tldr brew")
  end
end
