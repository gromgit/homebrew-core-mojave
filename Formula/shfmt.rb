class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v3.5.0.tar.gz"
  sha256 "d5a050d19df33b5c40939f49859ef118b4f9c0476f5b1172db2aaa7979c97cee"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/sh.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/shfmt"
    sha256 cellar: :any_skip_relocation, mojave: "c4b6c58d0604eb15936912769b259489145bbbb384780651acbfbe5a8c4c5f0f"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    (buildpath/"src/mvdan.cc").mkpath
    ln_sf buildpath, buildpath/"src/mvdan.cc/sh"
    system "go", "build", "-a", "-tags", "production brew", "-ldflags",
                          "-w -s -extldflags '-static' -X main.version=#{version}",
                          "-o", "#{bin}/shfmt", "./cmd/shfmt"
    man1.mkpath
    system "scdoc < ./cmd/shfmt/shfmt.1.scd > #{man1}/shfmt.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shfmt  --version")

    (testpath/"test").write "\t\techo foo"
    system "#{bin}/shfmt", testpath/"test"
  end
end
