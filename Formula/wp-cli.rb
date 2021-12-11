class WpCli < Formula
  desc "Command-line interface for WordPress"
  homepage "https://wp-cli.org/"
  url "https://github.com/wp-cli/wp-cli/releases/download/v2.5.0/wp-cli-2.5.0.phar"
  sha256 "be0853e9f443f3848566070871d344e8ad81eb1e15d15dcf9324b4a75e272789"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/wp-cli"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "62611a919422b04ae52e78e860dc4614adf80a476b13e3cea8c4e3e7c6fb727b"
  end

  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    pour_bottle? only_if: :default_prefix if Hardware::CPU.intel?
  end

  def install
    bin.install "wp-cli-#{version}.phar" => "wp"
  end

  test do
    output = shell_output("#{bin}/wp core download --path=wptest")
    assert_match "Success: WordPress downloaded.", output
  end
end
