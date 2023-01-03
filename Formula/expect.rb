class Expect < Formula
  desc "Program that can automate interactive applications"
  homepage "https://core.tcl-lang.org/expect/index"
  url "https://downloads.sourceforge.net/project/expect/Expect/5.45.4/expect5.45.4.tar.gz"
  sha256 "49a7da83b0bdd9f46d04a04deec19c7767bb9a323e40c4781f89caf760b92c34"
  license :public_domain
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/expect-?v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/expect"
    sha256 mojave: "773121ff721ceba1e0f8f228d1d66b441c35b2d7383b7ef8d60a8bc41a7d97ff"
  end

  # Autotools are introduced here to regenerate configure script. Remove
  # if the patch has been applied in newer releases.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "tcl-tk"

  conflicts_with "ircd-hybrid", because: "both install an `mkpasswd` binary"

  def install
    tcltk = Formula["tcl-tk"]
    args = %W[
      --prefix=#{prefix}
      --exec-prefix=#{prefix}
      --mandir=#{man}
      --enable-shared
      --enable-64bit
      --with-tcl=#{tcltk.opt_lib}
    ]

    # Temporarily workaround build issues with building 5.45.4 using Xcode 12.
    # Upstream bug (with more complicated fix) is here:
    #   https://core.tcl-lang.org/expect/tktview/0d5b33c00e5b4bbedb835498b0360d7115e832a0
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

    # Workaround for ancient config files not recognising aarch64 macos.
    am = Formula["automake"]
    am_share = am.opt_share/"automake-#{am.version.major_minor}"
    %w[config.guess config.sub].each do |fn|
      cp am_share/fn, "tclconfig/#{fn}"
    end

    # Regenerate configure script. Remove after patch applied in newer
    # releases.
    system "autoreconf", "--force", "--install", "--verbose"

    system "./configure", *args
    system "make"
    system "make", "install"
    lib.install_symlink Dir[lib/"expect*/libexpect*"]
    if OS.mac?
      bin.env_script_all_files libexec/"bin",
                               PATH:       "#{tcltk.opt_bin}:$PATH",
                               TCLLIBPATH: lib.to_s
      # "expect" is already linked to "tcl-tk", no shim required
      bin.install libexec/"bin/expect"
    end
  end

  test do
    assert_match "works", shell_output("echo works | #{bin}/timed-read 1")
    assert_equal "", shell_output("{ sleep 3; echo fails; } | #{bin}/timed-read 1 2>&1")
  end
end
