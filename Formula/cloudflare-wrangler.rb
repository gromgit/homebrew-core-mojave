class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/wrangler"
  url "https://github.com/cloudflare/wrangler/archive/v1.19.5.tar.gz"
  sha256 "91683895f1b382d991e7aabddda608c1203cd5ffe01b87aaaeaf2aab6d41e0c5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cloudflare/wrangler.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cloudflare-wrangler"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "a30c804eb68f4d69aa8e0372a62221e09474e3f7d31449a71d0732769686a277"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("CF_API_TOKEN=AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA #{bin}/wrangler whoami 2>&1", 1)
    assert_match "Failed to retrieve information about the email associated with", output
  end
end
