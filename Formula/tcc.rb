class Tcc < Formula
  desc "Tiny C compiler"
  homepage "https://bellard.org/tcc/"
  license "LGPL-2.0-or-later"
  revision 1
  head "https://repo.or.cz/tinycc.git", branch: "mob"

  stable do
    url "https://download.savannah.nongnu.org/releases/tinycc/tcc-0.9.27.tar.bz2"
    sha256 "de23af78fca90ce32dff2dd45b3432b2334740bb9bb7b05bf60fdbfc396ceb9c"

    # Big Sur and later are not supported
    # http://savannah.nongnu.org/bugs/?59640
    depends_on maximum_macos: :catalina
  end

  livecheck do
    url "https://download.savannah.nongnu.org/releases/tinycc/"
    regex(/href=.*?tcc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tcc"
    rebuild 1
    sha256 mojave: "595b8a2c250a266307a8de05a9b3e7f78eb9962935f0de3ec1ba9de99dcf655c"
  end

  def install
    # Add appropriate include paths for macOS or Linux.
    os_include_path = if OS.mac?
      MacOS.sdk_path/"usr/include"
    else
      "/usr/include:/usr/include/x86_64-linux-gnu"
    end

    args = %W[
      --prefix=#{prefix}
      --source-path=#{buildpath}
      --sysincludepaths=#{HOMEBREW_PREFIX}/include:#{os_include_path}:{B}/include
      --enable-cross
    ]
    args << "--cc=#{ENV.cc}" if build.head?

    ENV.deparallelize
    system "./configure", *args
    system "make", "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    system "make", "install"
  end

  test do
    (testpath/"hello-c.c").write <<~EOS
      #include <stdio.h>
      int main()
      {
        puts("Hello, world!");
        return 0;
      }
    EOS
    assert_equal "Hello, world!\n", shell_output("#{bin}/tcc -run hello-c.c")
  end
end
