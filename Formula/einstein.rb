class Einstein < Formula
  desc "Remake of the old DOS game Sherlock"
  homepage "https://github.com/lksj/einstein-puzzle"
  url "https://github.com/lksj/einstein-puzzle/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "46cf0806c3792b995343e46bec02426065f66421c870781475d6d365522c10fc"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/einstein"
    sha256 cellar: :any, mojave: "9814fd8121a68d78ffa9d8e2e4174b6f37ba4fcb75c65e0ad0a585f1c73ab5be"
  end

  depends_on "sdl"
  depends_on "sdl_mixer"
  depends_on "sdl_ttf"

  def install
    # Temporary Homebrew-specific work around for linker flag ordering problem in Ubuntu 16.04.
    # Remove after migration to 18.04.
    inreplace "Makefile", "$(LNFLAGS) $(OBJECTS)", "$(OBJECTS) $(LNFLAGS)" unless OS.mac?
    system "make", "PREFIX=#{HOMEBREW_PREFIX}"

    bin.install "einstein"
    (pkgshare/"res").install "einstein.res"
  end
end
