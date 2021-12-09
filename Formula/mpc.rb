class Mpc < Formula
  desc "Command-line music player client for mpd"
  homepage "https://www.musicpd.org/clients/mpc/"
  url "https://www.musicpd.org/download/mpc/0/mpc-0.34.tar.xz"
  sha256 "691e3f3654bc10d022bb0310234d0bc2d8c075a698f09924d9ebed8f506fda20"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.musicpd.org/download/mpc/0/"
    regex(/href=.*?mpc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mpc"
    sha256 cellar: :any, mojave: "8a04aafa411e526f7af5ad1152f0dc9ae857004cd06e2c0efcf2619cbf61fc01"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "libmpdclient"

  def install
    system "meson", *std_meson_args, ".", "output"
    system "ninja", "-C", "output"
    system "ninja", "-C", "output", "install"

    bash_completion.install "contrib/mpc-completion.bash" => "mpc"
    rm share/"doc/mpc/contrib/mpc-completion.bash"
  end

  test do
    assert_match "query", shell_output("#{bin}/mpc list 2>&1", 1)
    assert_match "-F _mpc", shell_output("bash -c 'source #{bash_completion}/mpc && complete -p mpc'")
  end
end
