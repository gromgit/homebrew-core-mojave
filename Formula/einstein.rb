class Einstein < Formula
  desc "Remake of the old DOS game Sherlock"
  homepage "https://github.com/lksj/einstein-puzzle"
  url "https://github.com/lksj/einstein-puzzle/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "46cf0806c3792b995343e46bec02426065f66421c870781475d6d365522c10fc"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/einstein"
    sha256 cellar: :any, mojave: "e0a7cf1c8a0e00e0a7bf999ea455c8087379217eb826d444ef79c4b6e26a2d82"
  end

  depends_on "sdl12-compat"
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
