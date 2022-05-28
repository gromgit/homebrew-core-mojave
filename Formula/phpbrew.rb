class Phpbrew < Formula
  desc "Brew & manage PHP versions in pure PHP at HOME"
  homepage "https://phpbrew.github.io/phpbrew"
  url "https://github.com/phpbrew/phpbrew/releases/download/1.27.0/phpbrew.phar"
  sha256 "0fdcda638851ef7e306f5046ff1f9de291443656a35f5150d84368c88aa7a41a"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/phpbrew"
    rebuild 3
    sha256 cellar: :any_skip_relocation, mojave: "47a62a4b064ea08edaa930c9657bc1453a2dacf4e80cf7ce7373c2d76a1e6a94"
  end

  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    pour_bottle? only_if: :default_prefix if Hardware::CPU.intel?
  end

  def install
    chmod "+x", "phpbrew.phar"
    bin.install "phpbrew.phar" => "phpbrew"
  end

  test do
    system bin/"phpbrew", "init"
    assert_match "8.0", shell_output("#{bin}/phpbrew known")
  end
end
