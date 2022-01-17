class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "https://www.treefrogframework.org/"
  url "https://github.com/treefrogframework/treefrog-framework/archive/v2.3.0.tar.gz"
  sha256 "e73f2c29d01fb4a41eefd4fc1394c8bf5aaa7d1646fcea88701c6de5621c8d05"
  license "BSD-3-Clause"
  head "https://github.com/treefrogframework/treefrog-framework.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/treefrog"
    sha256 mojave: "99a5a3e9d9ec13cb6be24f0284210e88c8ad8d1cf755829fca405bf5c70139ec"
  end

  depends_on xcode: :build
  depends_on "mongo-c-driver"
  depends_on "qt"

  def install
    inreplace "src/corelib.pro", "/usr/local", HOMEBREW_PREFIX

    system "./configure", "--prefix=#{prefix}", "--enable-shared-mongoc"

    cd "src" do
      system "make"
      system "make", "install"
    end

    cd "tools" do
      system "make"
      system "make", "install"
    end
  end

  test do
    ENV.delete "CPATH"
    system bin/"tspawn", "new", "hello"
    assert_predicate testpath/"hello", :exist?
    cd "hello" do
      assert_predicate Pathname.pwd/"hello.pro", :exist?
      system Formula["qt"].opt_bin/"qmake"
      assert_predicate Pathname.pwd/"Makefile", :exist?
      system "make"
      system bin/"treefrog", "-v"
    end
  end
end
