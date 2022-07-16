class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/2.2.tar.gz"
  sha256 "6a2467bf6bad00fb3fe3a7b9bdb4e6ea6d8a721b1c9905e6161324cfb3f34c01"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/circumflex"
    sha256 cellar: :any_skip_relocation, mojave: "4b5d1b28a8bb8c9e1480597130e0bae458b4a2f0a8f79fb4bd7d39bda9c373e0"
  end

  depends_on "go" => :build

  # Requires less 576 or later for --use-color
  depends_on "less" if MacOS.version <= :big_sur

  def install
    system "go", "build", *std_go_args(output: bin/"clx", ldflags: "-s -w")
  end

  test do
    assert_match "List of visited IDs cleared", shell_output("#{bin}/clx clear 2>&1")
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    assert_match "Y Combinator", shell_output("#{bin}/clx view 1")
  end
end
