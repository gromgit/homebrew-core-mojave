class Dstask < Formula
  desc "Git-powered personal task tracker"
  homepage "https://github.com/naggie/dstask"
  url "https://github.com/naggie/dstask/archive/v0.26.tar.gz"
  sha256 "ccd7afcb825eb799bdaaaf6eaf8150bbb8ceda02fec6c97f042b7bbc913a46fc"
  license "MIT"
  head "https://github.com/naggie/dstask.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dstask"
    sha256 cellar: :any_skip_relocation, mojave: "ee68b9443574714a4773cd91da4c4e5d03678aff5d9ae11d229fb1e53471d993"
  end

  depends_on "go" => :build

  def install
    system "go", "mod", "vendor"
    system "make", "dist/dstask"
    bin.install Dir["dist/*"]
  end

  test do
    mkdir ".dstask" do
      system "git", "init"
      system "git", "config", "user.name", "BrewTestBot"
      system "git", "config", "user.email", "BrewTestBot@test.com"
    end

    system bin/"dstask", "add", "Brew the brew"
    system bin/"dstask", "start", "1"
    output = shell_output("#{bin}/dstask show-active")
    assert_match "Brew the brew", output
    system bin/"dstask", "done", "1"
  end
end
