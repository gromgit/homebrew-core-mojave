class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/v0.29.0.tar.gz"
  sha256 "0b517b04ac8709a4ef3d92421b555710b67a5234f5e5e2e8d6c3479aee01697d"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/govc"
    sha256 cellar: :any_skip_relocation, mojave: "4f1604e94df9352bb1392167f2144edad3047110afc2d47e98b221f3db79d3b4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
