class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.79.tar.gz"
  sha256 "78be1c0a905184ed1cb506468359faf87e4ee86851291b1670439c46bfb3d87c"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/got"
    sha256 mojave: "cb31f053ac271ff7da0957d7bef4b0b15468d0537b4f05c9ee0b6375e371d642"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on :macos # FIXME: build fails on Linux.
  depends_on "ncurses"
  depends_on "openssl@1.1"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libmd"
    depends_on "util-linux" # for libuuid
  end

  def install
    # The `configure` script hardcodes our `openssl@3`, but we can't use it due to `libevent`.
    inreplace "configure", %r{\$\{HOMEBREW_PREFIX?\}/opt/openssl@3}, Formula["openssl@1.1"].opt_prefix
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    ENV["GOT_AUTHOR"] = "Flan Hacker <flan_hacker@openbsd.org>"
    system bin/"gotadmin", "init", "repo.git"
    mkdir "import-dir"
    %w[haunted house].each { |f| touch testpath/"import-dir"/f }
    system bin/"got", "import", "-m", "Initial Commit", "-r", "repo.git", "import-dir"
    system bin/"got", "checkout", "repo.git", "src"
  end
end
