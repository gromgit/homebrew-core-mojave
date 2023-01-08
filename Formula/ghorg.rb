class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://github.com/gabrie30/ghorg/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "82917744b06204ee721e865737a06f067e631b62ba78a19e5ba8b5c38afba896"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ghorg"
    sha256 cellar: :any_skip_relocation, mojave: "c61c7bb77ffc0e9b553e36efdd472693252f9d9658b9cb15a37aabc5086c0c46"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"ghorg", "completion")
  end

  test do
    assert_match "No clones found", shell_output("#{bin}/ghorg ls")
  end
end
