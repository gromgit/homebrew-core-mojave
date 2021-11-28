class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/v0.27.2.tar.gz"
  sha256 "5a128acde489e1e5bf43e8ae3ed9908cc132e06513c3a4ce0c4359937ae06702"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/govc"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "c5f4cd733e626deee035096a7c6765370bc11ea69d19cfa78bea2e0d92bfc907"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
