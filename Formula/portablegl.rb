class Portablegl < Formula
  desc "Implementation of OpenGL 3.x-ish in clean C"
  homepage "https://github.com/rswinkle/PortableGL"
  url "https://github.com/rswinkle/PortableGL.git",
    tag:      "0.94",
    revision: "ff02769271294639a3a91bef06c5a8b71fc55cfd"
  license "MIT"
  head "https://github.com/rswinkle/PortableGL.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/portablegl"
    sha256 cellar: :any_skip_relocation, mojave: "3d99239b728b64fd97d62b1115134c80c4343cd79765f911505b3ac6f9a2300d"
  end

  depends_on "python@3.11" => :test
  depends_on "sdl2" => :test

  def install
    include.install "portablegl.h"
    include.install "portablegl_unsafe.h"
    (pkgshare/"tests").install "glcommon"
    (pkgshare/"tests").install "testing"
  end

  test do
    python = Formula["python@3.11"].opt_bin/"python3.11"
    cp_r Dir["#{pkgshare}/tests/*"], testpath
    cd "testing" do
      system "make", "run_tests"
      assert_match "All tests passed", shell_output("#{python} check_tests.py")
    end
  end
end
