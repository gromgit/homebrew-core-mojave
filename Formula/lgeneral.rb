class Lgeneral < Formula
  desc "Turn-based strategy engine heavily inspired by Panzer General"
  homepage "https://lgames.sourceforge.io/LGeneral/"
  url "https://downloads.sourceforge.net/lgeneral/lgeneral/lgeneral-1.4.4.tar.gz"
  sha256 "0a26b495716cdcab63b49a294ba31649bc0abe74ce0df48276e52f4a6f323a95"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lgeneral"
    sha256 mojave: "79e8e3c17c9148ea5a0242d6f7dbc3e2ab090cbdf5780d1c2e8874f4c37c6b1e"
  end

  depends_on "gettext"
  depends_on "sdl12-compat"
  depends_on "sdl2"

  def install
    # Applied in community , to remove in next release
    inreplace "configure", "#include <unistd.h>", "#include <sys/stat.h>\n#include <unistd.h>"
    system "./configure", *std_configure_args,
                         "--disable-silent-rules",
                         "--disable-sdltest"
    system "make", "install"
  end

  def post_install
    %w[nations scenarios units sounds maps gfx].each { |dir| (pkgshare/dir).mkpath }
    %w[flags units terrain].each { |dir| (pkgshare/"gfx"/dir).mkpath }
  end

  def caveats
    <<~EOS
      Requires pg-data.tar.gz or the original DOS version of Panzer General. Can be downloaded from
      https://sourceforge.net/projects/lgeneral/files/lgeneral-data/pg-data.tar.gz/download
      To install use:
        lgc-pg -s <pg-data-unziped-dir> -d #{opt_pkgshare}
    EOS
  end

  test do
    system bin/"lgeneral", "--version"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    pid = fork do
      exec bin/"lgeneral"
    end
    sleep 3
    Process.kill "TERM", pid
  end
end
