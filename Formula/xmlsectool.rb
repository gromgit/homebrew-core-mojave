class Xmlsectool < Formula
  desc "Check schema validity and signature of an XML document"
  homepage "https://wiki.shibboleth.net/confluence/display/XSTJ3/xmlsectool+V3+Home"
  url "https://shibboleth.net/downloads/tools/xmlsectool/3.0.0/xmlsectool-3.0.0-bin.zip"
  sha256 "5b430dda0bf78df224495b39f83cf043d96c0ab9c8ccaa23fbdb56068c46abbc"
  license "Apache-2.0"

  livecheck do
    url "https://shibboleth.net/downloads/tools/xmlsectool/latest/"
    regex(/href=.*?xmlsectool[._-]v?(\d+(?:\.\d+)+)(?:-bin)?\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "08f56219830aaf82a142dd338e4fd6ebc48f48ade7cc1a23646d78cc7ca7d48f"
  end

  depends_on "openjdk"

  def install
    prefix.install "doc/LICENSE.txt"
    rm_rf "doc"
    libexec.install Dir["*"]
    (bin/"xmlsectool").write_env_script "#{libexec}/xmlsectool.sh", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    system "#{bin}/xmlsectool", "--listBlacklist"
  end
end
