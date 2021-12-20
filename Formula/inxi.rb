class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://github.com/smxi/inxi/archive/3.3.10-1.tar.gz"
  sha256 "0d4faa8a1b3f048d6f4ce49c64eb0e4628c63d16ffafad124cbebaca6922a302"
  license "GPL-3.0-or-later"
  head "https://github.com/smxi/inxi.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/inxi"
    sha256 cellar: :any_skip_relocation, mojave: "b81284918e2e159b895e0111e6f0593e61f7e4bbf2ed51fc37445227e6c5bbd8"
  end

  def install
    bin.install "inxi"
    man1.install "inxi.1"

    ["LICENSE.txt", "README.txt", "inxi.changelog"].each do |file|
      prefix.install file
    end
  end

  test do
    inxi_output = shell_output("#{bin}/inxi")

    uname = shell_output("uname").strip
    assert_match uname.to_str, inxi_output.to_s

    uname_r = shell_output("uname -r").strip
    assert_match uname_r.to_str, inxi_output.to_s
  end
end
