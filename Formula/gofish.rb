class Gofish < Formula
  desc "Cross-platform systems package manager"
  homepage "https://github.com/fishworks/gofish"
  url "https://github.com/fishworks/gofish.git",
      tag:      "v0.15.1",
      revision: "5d14f73963cfc0c226e8b06c0f5c3404d2ec2e77"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gofish"
    rebuild 3
    sha256 cellar: :any_skip_relocation, mojave: "fd61b86f39162deb97b04a43a3563eaed2b622e5365cffbbc3d2d0d50b79076d"
  end

  deprecate! date: "2022-06-21", because: :repo_archived

  depends_on "go" => :build

  def install
    system "make"
    bin.install "bin/gofish"
  end

  def caveats
    <<~EOS
      To activate gofish, run:
        gofish init
    EOS
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/gofish version")
  end
end
