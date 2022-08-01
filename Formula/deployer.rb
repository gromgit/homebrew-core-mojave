class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://github.com/deployphp/deployer/releases/download/v7.0.0/deployer.phar"
  sha256 "34a234b6acccd1b6f214df570ff118a9fcea91dc06be53f75d0fc702cc38ace5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ed7260dc5eb44314da6c26f8011961042f01b8731af4fae1a533d85ef5b0f4e4"
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
