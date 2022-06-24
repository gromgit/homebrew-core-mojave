class Gofish < Formula
  desc "Cross-platform systems package manager"
  homepage "https://github.com/fishworks/gofish"
  url "https://github.com/fishworks/gofish.git",
      tag:      "v0.15.1",
      revision: "5d14f73963cfc0c226e8b06c0f5c3404d2ec2e77"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gofish"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "10ec5ff54ecdc5cfea0d12d90fe1672f7182eee64aa85ecb17b09ba08ac2beef"
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
