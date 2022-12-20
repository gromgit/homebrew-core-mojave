class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  # Bump to php 8.2 on the next release, if possible.
  url "https://github.com/deployphp/deployer/releases/download/v7.0.2/deployer.phar"
  sha256 "0dd3d3a4aac4b27338359843fc9f4f974b06276c2854b41b6fd54b0786473936"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "945de0a43e6b2ba7b28bf7eaf9eaec43fe693b2563a2cbcce8d8a249c192b829"
  end

  depends_on "php@8.1"

  conflicts_with "dep", because: "both install `dep` binaries"

  def install
    bin.install "deployer.phar" => "dep"
    bin.env_script_all_files libexec, PATH: "#{Formula["php@8.1"].opt_bin}:$PATH"
    chmod 0755, libexec/"dep"
  end

  test do
    system "#{bin}/dep", "init", "--no-interaction"
    assert_predicate testpath/"deploy.php", :exist?
  end
end
