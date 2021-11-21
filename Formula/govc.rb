class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/v0.27.1.tar.gz"
  sha256 "8b5f0748b6bbbd1088950769bb82c44431478a9e80f729ab791fff9862d89a09"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/govc"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "2d92feccb1915bd5a53ffd3ac81eded328d564da7be04371476ab19d15045176"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
