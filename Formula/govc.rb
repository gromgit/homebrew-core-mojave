class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/v0.27.3.tar.gz"
  sha256 "3f40f82b325910b713b8a325a7483f55211e9ddebe6996422a3c38cf5eeb80a0"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/govc"
    sha256 cellar: :any_skip_relocation, mojave: "136bef09bde06201b8aff013716d960aea73a4c7ff4b85f2850123fb664d14dc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
