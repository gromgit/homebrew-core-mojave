class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/v0.30.0.tar.gz"
  sha256 "78c26fa3958ebf2dbf919b36ffe5b82bc02071bb3a060bc806a44d91f9a65426"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/govc"
    sha256 cellar: :any_skip_relocation, mojave: "f6c3078c9b4df8f36ab15835914b9199412b2af7d9461dbb78ea20313f18ebb9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
