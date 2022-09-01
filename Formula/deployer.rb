class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://github.com/deployphp/deployer/releases/download/v7.0.1/deployer.phar"
  sha256 "63119af2c18d5be19f91a8fb9665ac00217190d5e08cc0ad83510a558dd53794"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7fc6d1d75cd13d0af6b27cd9d944f6860c6c98970e76b5636ecf84f1e08e3d71"
  end

  depends_on "php"

  conflicts_with "dep", because: "both install `dep` binaries"

  def install
    bin.install "deployer.phar" => "dep"
  end

  test do
    system "#{bin}/dep", "init", "--no-interaction"
    assert_predicate testpath/"deploy.php", :exist?
  end
end
