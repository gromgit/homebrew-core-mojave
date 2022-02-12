class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/v0.27.4.tar.gz"
  sha256 "e09c0596639c1213254c501478a566cbb9e7fe64d9162d0ae93c7504c1002bdd"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/govc"
    sha256 cellar: :any_skip_relocation, mojave: "7375fc4bdffbce96698ce550f467989000fa705a2c9b8c4c7d747033baa59ac4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
