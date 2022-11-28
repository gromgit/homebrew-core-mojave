class Bsdmake < Formula
  desc "BSD version of the Make build tool"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/bsdmake/archive/refs/tags/bsdmake-24.tar.gz"
  sha256 "096f333f94193215931a9fab86b9bca0713fbd22ec465bf55510067b53940e62"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "BSD-4-Clause-UC"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bsdmake"
    rebuild 3
    sha256 mojave: "bc314fff46d4ebbe1f815c3505920c40efa049e2161f8e4554ddace4569dd44b"
  end

  # MacPorts patches to make bsdmake play nice with our prefix system
  # Also a MacPorts patch to circumvent setrlimit error
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/1fcaddfc/bsdmake/patch-Makefile.diff"
    sha256 "1e247cb7d8769d50e675e3f66b6f19a1bc7663a7c0800fc29a2489f3f6397242"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/1fcaddfc/bsdmake/patch-mk.diff"
    sha256 "b7146bfe7a28fc422e740e28e56e5bf0166a29ddf47a54632ad106bca2d72559"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/1fcaddfc/bsdmake/patch-pathnames.diff"
    sha256 "b24d73e5fe48ac2ecdfbe381e9173f97523eed5b82a78c69dcdf6ce936706ec6"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/1fcaddfc/bsdmake/patch-setrlimit.diff"
    sha256 "cab53527564d775d9bd9a6e4969f116fdd85bcf0ad3f3e57ec2dcc648f7ed448"
  end

  def install
    # Replace @PREFIX@ inserted by MacPorts patches
    inreplace %w[mk/bsd.README
                 mk/bsd.cpu.mk
                 mk/bsd.doc.mk
                 mk/bsd.obj.mk
                 mk/bsd.own.mk
                 mk/bsd.port.mk
                 mk/bsd.port.subdir.mk
                 mk/sys.mk
                 pathnames.h],
                 "@PREFIX@", prefix

    inreplace "mk/bsd.own.mk" do |s|
      s.gsub! "@INSTALL_USER@", `id -un`.chomp
      s.gsub! "@INSTALL_GROUP@", `id -gn`.chomp
    end

    # See GNUMakefile
    ENV.append "CFLAGS", "-D__FBSDID=__RCSID"
    ENV.append "CFLAGS", "-mdynamic-no-pic"

    system "make", "-f", "Makefile.dist"
    bin.install "pmake" => "bsdmake"
    man1.install "make.1" => "bsdmake.1"
    (share/"mk/bsdmake").install Dir["mk/*"]
  end

  test do
    (testpath/"Makefile").write <<~EOS
      foo:
      \ttouch $@
    EOS

    system "#{bin}/bsdmake"
    assert_predicate testpath/"foo", :exist?
  end
end
