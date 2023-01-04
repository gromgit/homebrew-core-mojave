class FuegoFirestore < Formula
  desc "Command-line client for the Firestore database"
  homepage "https://github.com/sgarciac/fuego"
  url "https://github.com/sgarciac/fuego/archive/refs/tags/0.33.0.tar.gz"
  sha256 "25281f2242fe41b0533255a0d4f0450b1f3f8622d1585f8ae8cda1b116ca75d0"
  license "GPL-3.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fuego-firestore"
    sha256 cellar: :any_skip_relocation, mojave: "2235fe1fb651aa3b822067d0f6752e86d5e16a48aba2995e11f4de653cb5da5e"
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
