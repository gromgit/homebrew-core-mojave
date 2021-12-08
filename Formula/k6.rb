class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/loadimpact/k6/archive/v0.35.0.tar.gz"
  sha256 "52d81754f2d4e23f180eb094b0a203c9162dda177a23b8aa3b96bd84981a31a7"
  license "AGPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/k6"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "9e7f87b5a5c8136e06e5a2122d845d55ce8a0804339efc6f724a58247629520d"
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
