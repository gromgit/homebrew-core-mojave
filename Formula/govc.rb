class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/v0.27.4.tar.gz"
  sha256 "e09c0596639c1213254c501478a566cbb9e7fe64d9162d0ae93c7504c1002bdd"
  license "Apache-2.0"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/govc"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "9462be66fb35f23d485a93044dde3e9821fcc2e82d628b2ed3971aaec25a627d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
