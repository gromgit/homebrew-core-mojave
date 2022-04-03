class Heksa < Formula
  desc "CLI hex dumper with colors"
  homepage "https://github.com/raspi/heksa"
  url "https://github.com/raspi/heksa.git",
      tag:      "v1.14.0",
      revision: "045ea335825556c856b2f4dee606ae91c61afe7d"
  license "Apache-2.0"
  head "https://github.com/raspi/heksa.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/heksa"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "5a55b7b3d7a9ecddb7ba932ac653bcfdd14be8255f4f63244f13b05be63e842c"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "bin/heksa"
  end

  test do
    require "pty"

    r, _w, pid = PTY.spawn("#{bin}/heksa -l 16 -f asc -o no #{test_fixtures("test.png")}")

    # remove ANSI colors
    output = r.read.gsub(/\e\[([;\d]+)?m/, "")
    assert_match(/^.PNG/, output)

    Process.wait(pid)
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
