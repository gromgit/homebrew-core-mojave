class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://github.com/smxi/inxi/archive/3.3.08-1.tar.gz"
  sha256 "44008d9e77dc82855fd91d634f5f817813eb4653e4df7106e56a1c9986ab8abd"
  license "GPL-3.0-or-later"
  head "https://github.com/smxi/inxi.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/inxi"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "92651fc01715c0e10b00e2c29f4218aa8adba003321f84d33cf3f4411fa88564"
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
