class Tfschema < Formula
  desc "Schema inspector for Terraform providers"
  homepage "https://github.com/minamijoyo/tfschema"
  url "https://github.com/minamijoyo/tfschema/archive/v0.7.5.tar.gz"
  sha256 "0642b125805e812675f542feb5f2ab54bdf5660c12c93f86e90469407b204a04"
  license "MIT"
  head "https://github.com/minamijoyo/tfschema.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tfschema"
    sha256 cellar: :any_skip_relocation, mojave: "e14a49aac9f124ba8a245ce3757512847cdde3d297df38e1cbabef90d246d10f"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build
  depends_on "terraform" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"provider.tf").write "provider \"aws\" {}"
    system Formula["terraform"].bin/"terraform", "init"
    assert_match "permissions_boundary", shell_output("#{bin}/tfschema resource show aws_iam_user")

    assert_match version.to_s, shell_output("#{bin}/tfschema --version")
  end
end
