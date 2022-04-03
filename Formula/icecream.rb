class Icecream < Formula
  desc "Distributed compiler with a central scheduler to share build load"
  homepage "https://en.opensuse.org/Icecream"
  url "https://github.com/icecc/icecream/archive/1.4.tar.gz"
  sha256 "249dcf74f0fc477ff9735ff0bdcdfaa4c257a864c4db5255d8b25c9f4fd20b6b"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/icecream"
    sha256 mojave: "651d9034ce6bfe00b411d98320e10bff049e421f6d3ded1e30a29ceb822d1acd"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docbook2x" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libarchive"
  depends_on "lzo"
  depends_on "zstd"

  on_linux do
    depends_on "llvm" => :test
    depends_on "libcap-ng"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-clang-wrappers
    ]

    system "./autogen.sh"
    system "./configure", *args
    system "make", "install"

    # Manually install scheduler property list
    (prefix/"#{plist_name}-scheduler.plist").write scheduler_plist
  end

  def caveats
    <<~EOS
      To override the toolset with icecc, add to your path:
        #{opt_libexec}/icecc/bin
    EOS
  end

  service do
    run opt_sbin/"iceccd"
  end

  def scheduler_plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
          <key>Label</key>
          <string>#{plist_name}-scheduler</string>
          <key>ProgramArguments</key>
          <array>
          <string>#{sbin}/icecc-scheduler</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
      </dict>
      </plist>
    EOS
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
    system opt_libexec/"icecc/bin/gcc", "-o", "hello-c", "hello-c.c"
    assert_equal "Hello, world!\n", shell_output("./hello-c")

    (testpath/"hello-cc.cc").write <<~EOS
      #include <iostream>
      int main()
      {
        std::cout << "Hello, world!" << std::endl;
        return 0;
      }
    EOS
    system opt_libexec/"icecc/bin/g++", "-o", "hello-cc", "hello-cc.cc"
    assert_equal "Hello, world!\n", shell_output("./hello-cc")

    (testpath/"hello-clang.c").write <<~EOS
      #include <stdio.h>
      int main()
      {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system opt_libexec/"icecc/bin/clang", "-o", "hello-clang", "hello-clang.c"
    assert_equal "Hello, world!\n", shell_output("./hello-clang")

    (testpath/"hello-cclang.cc").write <<~EOS
      #include <iostream>
      int main()
      {
        std::cout << "Hello, world!" << std::endl;
        return 0;
      }
    EOS
    system opt_libexec/"icecc/bin/clang++", "-o", "hello-cclang", "hello-cclang.cc"
    assert_equal "Hello, world!\n", shell_output("./hello-cclang")
  end
end
