class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/Findomain"
  url "https://github.com/Findomain/Findomain/archive/8.0.0.tar.gz"
  sha256 "15f3447208d6db5e3f5725560424a57a3558e7015cd9777292162c8684227976"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/findomain"
    sha256 cellar: :any_skip_relocation, mojave: "f3070e36949df88d26f7d68c65a7a15a92ec66cbbc6cfdc1fffd05d56b82cf41"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
