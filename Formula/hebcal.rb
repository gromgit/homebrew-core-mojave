class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v5.7.0.tar.gz"
  sha256 "88a1f2492b4be94f2ad32d42441e996938f3c637c5e6e7e13120b01d8fa09db2"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hebcal"
    sha256 cellar: :any_skip_relocation, mojave: "bd9bbdbf589ddc86d9754f94262cc7c1b815abefe7431894bb0caa83be072ba2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/hebcal 01 01 2020").chomp
    assert_equal output, "1/1/2020 4th of Tevet, 5780"
  end
end
