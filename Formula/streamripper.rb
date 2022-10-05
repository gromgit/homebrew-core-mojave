class Streamripper < Formula
  desc "Separate tracks via Shoutcasts title-streaming"
  homepage "https://streamripper.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/streamripper/streamripper%20%28current%29/1.64.6/streamripper-1.64.6.tar.gz"
  sha256 "c1d75f2e9c7b38fd4695be66eff4533395248132f3cc61f375196403c4d8de42"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/streamripper[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/streamripper"
    sha256 cellar: :any, mojave: "4fe63f8b3a8de83fb30571048610b4ec029e88b7f0691bb8b331c05503db3880"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "mad"

  def install
    # the Makefile ignores CPPFLAGS from the environment, which
    # breaks the build when HOMEBREW_PREFIX is not /usr/local
    ENV.append_to_cflags ENV.cppflags

    # remove bundled libmad
    (buildpath/"libmad-0.15.1b").rmtree

    chmod 0755, "./install-sh" # or "make install" fails

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "#{bin}/streamripper", "--version"
  end
end
