class Gron < Formula
  desc "Make JSON greppable"
  homepage "https://github.com/tomnomnom/gron"
  url "https://github.com/tomnomnom/gron/archive/v0.6.1.tar.gz"
  sha256 "eef150a425aa4eaa8b2e36a75ee400d4247525403f79e24ed32ccb346dc653ff"
  license "MIT"
  head "https://github.com/tomnomnom/gron.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gron"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "58961388d1d1ee0ea57af1f94a8016345d71cfbd2873472885a8825d65ec7de5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal <<~EOS, pipe_output("#{bin}/gron", "{\"foo\":1, \"bar\":2}")
      json = {};
      json.bar = 2;
      json.foo = 1;
    EOS
  end
end
