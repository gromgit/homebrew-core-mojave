class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/v0.40.0.tar.gz"
  sha256 "d3e00387c6dda4e53b3816175b8772db53124198d8ceb499c9a1f6b76092df83"
  license "AGPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/k6"
    sha256 cellar: :any_skip_relocation, mojave: "5daf03a916f88647348cd869674ded432cb42b4784dcb4ea3c8ff9f920a28461"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"whatever.js").write <<~EOS
      export default function() {
        console.log("whatever");
      }
    EOS

    assert_match "whatever", shell_output("#{bin}/k6 run whatever.js 2>&1")
    assert_match version.to_s, shell_output("#{bin}/k6 version")
  end
end
