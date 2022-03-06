class GitTracker < Formula
  desc "Integrate Pivotal Tracker into your Git workflow"
  homepage "https://github.com/stevenharman/git_tracker"
  url "https://github.com/stevenharman/git_tracker/archive/v2.0.0.tar.gz"
  sha256 "ec0a8d6dd056b8ae061d9ada08f1cc2db087e13aaecf4e0d150c1808e0250504"
  license "MIT"
  head "https://github.com/stevenharman/git_tracker.git", branch: "main"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-tracker"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "9c2307d7310f530da8c7a68e272d5dd7f6f81ddcfed91e87a888cd45a404c528"
  end

  def install
    system "rake", "standalone:install", "prefix=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/git-tracker help")
    assert_match(/git-tracker \d+(\.\d+)* is installed\./, output)
  end
end
