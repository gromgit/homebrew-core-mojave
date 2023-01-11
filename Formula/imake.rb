class Imake < Formula
  desc "Build automation system written for X11"
  homepage "https://xorg.freedesktop.org"
  url "https://xorg.freedesktop.org/releases/individual/util/imake-1.0.9.tar.xz"
  sha256 "72de9d278f74d95d320ec7b0d745296f582264799eab908260dbea0ce8e08f83"
  license "MIT"

  livecheck do
    url "https://xorg.freedesktop.org/releases/individual/util/"
    regex(/href=.*?imake[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/imake"
    sha256 mojave: "8d506d755bc6a1da360651d2dd776d370973bcb3872a45e24983bfaf6fdb42de"
  end

  depends_on "pkg-config" => :build
  depends_on "xorgproto" => :build
  depends_on "tradcpp"

  resource "xorg-cf-files" do
    url "https://xorg.freedesktop.org/releases/individual/util/xorg-cf-files-1.0.6.tar.bz2"
    sha256 "4dcf5a9dbe3c6ecb9d2dd05e629b3d373eae9ba12d13942df87107fdc1b3934d"
  end

  def install
    ENV.deparallelize

    # imake runtime is broken when used with clang's cpp
    cpp_program = Formula["tradcpp"].opt_bin/"tradcpp"
    (buildpath/"imakemdep.h").append_lines [
      "#define DEFAULT_CPP \"#{cpp_program}\"",
      "#undef USE_CC_E",
    ]
    inreplace "imake.man", /__cpp__/, cpp_program

    # also use gcc's cpp during buildtime to pass ./configure checks
    ENV["RAWCPP"] = cpp_program

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"

    resource("xorg-cf-files").stage do
      # Fix for different X11 locations.
      inreplace "X11.rules", "define TopXInclude	/**/",
                "define TopXInclude	-I#{HOMEBREW_PREFIX}/include"
      system "./configure", "--with-config-dir=#{lib}/X11/config",
                            "--prefix=#{HOMEBREW_PREFIX}"
      system "make", "install"
    end
  end

  test do
    # Use pipe_output because the return code is unimportant here.
    output = pipe_output("#{bin}/imake -v -s/dev/null -f/dev/null -T/dev/null 2>&1")
    assert_match "#{Formula["tradcpp"].opt_bin}/tradcpp", output
  end
end
