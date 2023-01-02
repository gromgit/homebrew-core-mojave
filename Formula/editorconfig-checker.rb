class EditorconfigChecker < Formula
  desc "Tool to verify that your files are in harmony with your .editorconfig"
  homepage "https://github.com/editorconfig-checker/editorconfig-checker"
  url "https://github.com/editorconfig-checker/editorconfig-checker/archive/refs/tags/2.6.0.tar.gz"
  sha256 "21c3ddffa915f0cd857cef580025a6ff86cdd8b78c6026a2d841d2ca482b48e7"
  license "MIT"
  head "https://github.com/editorconfig-checker/editorconfig-checker.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/editorconfig-checker"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "c8ee222a7e21c09260e94a6a71585603314ca6ea12931bc23cd4c43a59884db5"
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
