class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/2.2.tar.gz"
  sha256 "6a2467bf6bad00fb3fe3a7b9bdb4e6ea6d8a721b1c9905e6161324cfb3f34c01"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/circumflex"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "ab044225900579cc9c99b6319d7ee651e5f6a767108dc5f4955aadebc02da657"
  end

  depends_on "go" => :build

  # Requires less 576 or later for --use-color
  uses_from_macos "less", since: :monterey

  def install
    system "go", "build", *std_go_args(output: bin/"clx", ldflags: "-s -w")
  end

  test do
    assert_match "List of visited IDs cleared", shell_output("#{bin}/clx clear 2>&1")
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    assert_match "Y Combinator", shell_output("#{bin}/clx view 1")
  end
end
