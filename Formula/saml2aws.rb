class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws.git",
  tag:      "v2.36.0",
  revision: "6957a7412352d3ce930a99417d0640f38525811f"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/saml2aws"
    sha256 cellar: :any_skip_relocation, mojave: "86acb32d579de8425bd3304f95dc722658ffd6e51719f63a67f0d4ae164462fc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.Version=#{version}", "./cmd/saml2aws"
  end

  test do
    assert_match "error building login details: Failed to validate account.: URL empty in idp account",
      shell_output("#{bin}/saml2aws script 2>&1", 1)
  end
end
