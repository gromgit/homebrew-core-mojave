class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://github.com/smxi/inxi/archive/3.3.23-1.tar.gz"
  sha256 "e85bcd9d28bcb094ae0015339bfb15267d5fcf369a712dea878b21d5372a222a"
  license "GPL-3.0-or-later"
  head "https://github.com/smxi/inxi.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/inxi"
    sha256 cellar: :any_skip_relocation, mojave: "c6db1e9b1b68b2f8bee1684d11ec89c1017c76350a99f2c02353e4eb568650ae"
  end

  uses_from_macos "perl"

  def install
    bin.install "inxi"
    man1.install "inxi.1"

    ["LICENSE.txt", "README.txt", "inxi.changelog"].each do |file|
      prefix.install file
    end
  end

  test do
    inxi_output = shell_output("#{bin}/inxi")
    uname_r = shell_output("uname -r").strip
    assert_match uname_r.to_str, inxi_output.to_s
  end
end
