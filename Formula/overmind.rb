class Overmind < Formula
  desc "Process manager for Procfile-based applications and tmux"
  homepage "https://github.com/DarthSim/overmind"
  url "https://github.com/DarthSim/overmind/archive/v2.3.0.tar.gz"
  sha256 "a9fe0efc94b72ca11003940145ca4d48a8af32e5e9593d1a53757dd2eccacbb2"
  license "MIT"
  head "https://github.com/DarthSim/overmind.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/overmind"
    sha256 cellar: :any_skip_relocation, mojave: "797014abf41687e3f52dbf940f2d66dcce909831df481e8eccd2b567a4d3d6df"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build
  depends_on "tmux"

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"overmind"
    prefix.install_metafiles
  end

  test do
    expected_message = "overmind: open ./Procfile: no such file or directory"
    assert_match expected_message, shell_output("#{bin}/overmind start 2>&1", 1)
    (testpath/"Procfile").write("test: echo 'test message'; sleep 1")
    expected_message = "test message"
    assert_match expected_message, shell_output("#{bin}/overmind start")
  end
end
