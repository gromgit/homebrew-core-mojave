class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/Findomain"
  url "https://github.com/Findomain/Findomain/archive/5.1.1.tar.gz"
  sha256 "a9484b4eff93ccba3c5ca6c1b480ecda1cfd8473457d2aa5cdb65c4510f9c337"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/findomain"
    sha256 cellar: :any_skip_relocation, mojave: "db20250460bd3785fbca5f57663f8640f93d153a6696ea10a019b5fd4dcedd8b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
