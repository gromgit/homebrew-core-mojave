class Matterbridge < Formula
  desc "Protocol bridge for multiple chat platforms"
  homepage "https://github.com/42wim/matterbridge"
  url "https://github.com/42wim/matterbridge/archive/v1.24.1.tar.gz"
  sha256 "ee2177f458a29dd8b4547cd6268fb8ac7e2ce2b551475427eca1205d67c236f4"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/matterbridge"
    sha256 cellar: :any_skip_relocation, mojave: "c2474edc9f49d5a53316213ac5bd28f40da5db76c63fee505a95e676ccf52167"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    touch testpath/"test.toml"
    assert_match "no [[gateway]] configured", shell_output("#{bin}/matterbridge -conf test.toml 2>&1", 1)
  end
end
