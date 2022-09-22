class Mlton < Formula
  desc "Whole-program, optimizing compiler for Standard ML"
  homepage "http://mlton.org"
  url "https://downloads.sourceforge.net/project/mlton/mlton/20210117/mlton-20210117.src.tgz"
  version "20210117"
  sha256 "ec7a5a54deb39c7c0fa746d17767752154e9cb94dbcf3d15b795083b3f0f154b"
  license "HPND"
  version_scheme 1
  head "https://github.com/MLton/mlton.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/mlton[._-]v?(\d+(?:\.\d+)*(?:-\d+)?)[._-]src\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mlton"
    rebuild 1
    sha256 cellar: :any, mojave: "d044459fcc80384bb59a3e08fd305b506bbe1f7f8609b769b7aa81dd62043156"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gmp"

  # The corresponding upstream binary release used to bootstrap.
  resource "bootstrap" do
    on_macos do
      # https://github.com/Homebrew/homebrew-core/pull/58438#issuecomment-665375929
      # new `mlton-20210117-1.amd64-darwin-17.7.gmp-static.tgz` artifact
      # used here for bootstrapping all homebrew versions
      url "https://downloads.sourceforge.net/project/mlton/mlton/20210117/mlton-20210117-1.amd64-darwin-19.6.gmp-static.tgz"
      sha256 "5bea9f60136ea6847890c5f4e45d7126a32ef14fd46a2303cab875ca95c8cd76"
    end

    on_linux do
      url "https://downloads.sourceforge.net/project/mlton/mlton/20210117/mlton-20210117-1.amd64-linux-glibc2.23.tgz"
      sha256 "5ac30fe415dd9bf727327980391df2556fed3f8422e36624db1ce0e9f7fba1e5"
    end
  end

  def install
    # Install the corresponding upstream binary release to 'bootstrap'.
    bootstrap = buildpath/"bootstrap"
    resource("bootstrap").stage do
      args = %W[
        WITH_GMP_DIR=#{Formula["gmp"].opt_prefix}
        PREFIX=#{bootstrap}
        MAN_PREFIX_EXTRA=/share
      ]
      system "make", *(args + ["install"])
    end
    ENV.prepend_path "PATH", bootstrap/"bin"

    # Support parallel builds (https://github.com/MLton/mlton/issues/132)
    ENV.deparallelize
    args = %W[
      WITH_GMP_DIR=#{Formula["gmp"].opt_prefix}
      DESTDIR=
      PREFIX=#{prefix}
      MAN_PREFIX_EXTRA=/share
    ]
    args << "OLD_MLTON_COMPILE_ARGS=-link-opt '-no-pie'" if OS.linux?
    system "make", *(args + ["all"])
    system "make", *(args + ["install"])
  end

  test do
    (testpath/"hello.sml").write <<~'EOS'
      val () = print "Hello, Homebrew!\n"
    EOS
    system "#{bin}/mlton", "hello.sml"
    assert_equal "Hello, Homebrew!\n", `./hello`
  end
end
