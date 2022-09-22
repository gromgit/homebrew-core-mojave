class FuegoFirestore < Formula
  desc "Command-line client for the Firestore database"
  homepage "https://github.com/sgarciac/fuego"
  url "https://github.com/sgarciac/fuego/archive/refs/tags/0.32.0.tar.gz"
  sha256 "ed16bcdef7e3463fbd12bd5daba80b36401ed0ea2ea4acc699eecde3d91b17fd"
  license "GPL-3.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fuego-firestore"
    sha256 cellar: :any_skip_relocation, mojave: "dea5e0b7031c86b676125e5a127c076095605027f41e22faad23c10aaebe25c8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"fuego", ldflags: "-s -w")
  end

  test do
    collections_output = shell_output("#{bin}/fuego collections 2>&1", 80)
    assert_match "Failed to create client.", collections_output
  end
end
