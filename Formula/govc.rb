class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/v0.27.2.tar.gz"
  sha256 "5a128acde489e1e5bf43e8ae3ed9908cc132e06513c3a4ce0c4359937ae06702"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/govc"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "02adf8587f211802320f94ca77260829ca4707a6060cd1493ac38a063f9ee3a0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
