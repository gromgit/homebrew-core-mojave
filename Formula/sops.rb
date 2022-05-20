class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://github.com/mozilla/sops"
  url "https://github.com/mozilla/sops/archive/v3.7.3.tar.gz"
  sha256 "0e563f0c01c011ba52dd38602ac3ab0d4378f01edfa83063a00102587410ac38"
  license "MPL-2.0"
  head "https://github.com/mozilla/sops.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sops"
    sha256 cellar: :any_skip_relocation, mojave: "0e7ecd46a72a65dc3475a9265c244903221f0ee3d9df05c8720034f2461e27b5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"sops", "go.mozilla.org/sops/v3/cmd/sops"
    pkgshare.install "example.yaml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sops --version")

    assert_match "Recovery failed because no master key was able to decrypt the file.",
      shell_output("#{bin}/sops #{pkgshare}/example.yaml 2>&1", 128)
  end
end
