class Matterbridge < Formula
  desc "Protocol bridge for multiple chat platforms"
  homepage "https://github.com/42wim/matterbridge"
  url "https://github.com/42wim/matterbridge/archive/v1.25.1.tar.gz"
  sha256 "26fd8500334118c2eb3910ea9fa8fbd955aace59209cedf01179b29c072290fe"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/matterbridge"
    sha256 cellar: :any_skip_relocation, mojave: "a6d7b47713e1abf7caa6c320d9759448e2b83a617c698f7b5204af393087e25e"
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
