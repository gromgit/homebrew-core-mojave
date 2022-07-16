class EditorconfigChecker < Formula
  desc "Tool to verify that your files are in harmony with your .editorconfig"
  homepage "https://github.com/editorconfig-checker/editorconfig-checker"
  url "https://github.com/editorconfig-checker/editorconfig-checker/archive/refs/tags/2.5.0.tar.gz"
  sha256 "50274a09c760303bc88c0ead319eda4bc6f317764a1cade1ea86e9ff17d7c0b1"
  license "MIT"
  head "https://github.com/editorconfig-checker/editorconfig-checker.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/editorconfig-checker"
    sha256 cellar: :any_skip_relocation, mojave: "194fefdf129325e08b95f4158ecd48f673a3099203516429a88010c943bb79be"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/editorconfig-checker/main.go"
  end

  test do
    (testpath/"version.txt").write <<~EOS
      version=#{version}
    EOS

    system bin/"editorconfig-checker", testpath/"version.txt"
    assert_match version.to_s, shell_output("#{bin}/editorconfig-checker --version")
  end
end
