class Gron < Formula
  desc "Make JSON greppable"
  homepage "https://github.com/tomnomnom/gron"
  url "https://github.com/tomnomnom/gron/archive/v0.7.1.tar.gz"
  sha256 "1c98f2ef2ba03558864b1ab5e9c4b47a2e89d3ffaf24cfa0ac75cd38d775feb4"
  license "MIT"
  head "https://github.com/tomnomnom/gron.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gron"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "a2f11e94354fe178fca266d8204f4cbbb3c1bd6bfb6b3a18777dde398f427b18"
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
