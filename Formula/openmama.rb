class Openmama < Formula
  desc "Open source high performance messaging API for various Market Data sources"
  homepage "https://openmama.finos.org"
  url "https://github.com/finos/OpenMAMA/archive/OpenMAMA-6.3.1-release.tar.gz"
  sha256 "43e55db00290bc6296358c72e97250561ed4a4bb3961c1474f0876b81ecb6cf9"
  license "LGPL-2.1-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/openmama"
    rebuild 2
    sha256 cellar: :any, mojave: "d8d9d61f31bd81737971917bf8d0f3924a64fe9987d5e55a8177ebb22773d204"
  end

  depends_on "cmake" => :build
  depends_on "apr"
  depends_on "apr-util"
  depends_on "libevent"
  depends_on "qpid-proton"

  uses_from_macos "flex" => :build

  on_macos do
    depends_on "ossp-uuid"
  end

  # UUID is provided by util-linux on Linux.
  on_linux do
    depends_on "util-linux"
  end

  def install
    mkdir "build" do
      system "cmake", "..", "-DAPR_ROOT=#{Formula["apr"].opt_prefix}",
                            "-DPROTON_ROOT=#{Formula["qpid-proton"].opt_prefix}",
                            "-DCMAKE_INSTALL_RPATH=#{rpath}",
                            "-DINSTALL_RUNTIME_DEPENDENCIES=OFF",
                            "-DWITH_TESTTOOLS=OFF",
                            *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/mamalistenc", "-?"
    (testpath/"test.c").write <<~EOS
      #include <mama/mama.h>
      #include <stdio.h>
      int main() {
          mamaBridge bridge;
          fclose(stderr);
          mama_status status = mama_loadBridge(&bridge, "qpid");
          if (status != MAMA_STATUS_OK) return 1;
          const char* version = mama_getVersion(bridge);
          if (NULL == version) return 2;
          printf("%s\\n", version);
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmama", "-o", "test"
    assert_includes shell_output("./test"), version.to_s
  end
end
