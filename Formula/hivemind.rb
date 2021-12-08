class Hivemind < Formula
  desc "Process manager for Procfile-based applications"
  homepage "https://github.com/DarthSim/hivemind"
  url "https://github.com/DarthSim/hivemind/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "b4f7259663ef5b99906af0d98fe4b964d8f9a4d86a8f5aff30ab8df305d3a996"
  license "MIT"
  head "https://github.com/DarthSim/hivemind.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hivemind"
    sha256 cellar: :any_skip_relocation, mojave: "b7cda984478f615e7c09b252fc230c731008d851e6e541977771d207afc511fc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"Procfile").write("test: echo 'test message'")
    assert_match "test message", shell_output("#{bin}/hivemind")
  end
end
