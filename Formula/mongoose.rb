class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/7.7.tar.gz"
  sha256 "4e5733dae31c3a81156af63ca9aa3a6b9b736547f21f23c3ab2f8e3f1ecc16c0"
  license "GPL-2.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mongoose"
    sha256 cellar: :any, mojave: "cf7c229b9c683f3914bd79143393229f7e5f0fd306e912ff15bdcbfb433f72b6"
  end

  depends_on "openssl@1.1"

  conflicts_with "suite-sparse", because: "suite-sparse vendors libmongoose.dylib"

  def install
    # No Makefile but is an expectation upstream of binary creation
    # https://github.com/cesanta/mongoose/issues/326
    cd "examples/http-server" do
      system "make", "mongoose_mac", "PROG=mongoose_mac"
      bin.install "mongoose_mac" => "mongoose"
    end

    system ENV.cc, "-dynamiclib", "mongoose.c", "-o", "libmongoose.dylib" if OS.mac?
    if OS.linux?
      system ENV.cc, "-fPIC", "-c", "mongoose.c"
      system ENV.cc, "-shared", "-Wl,-soname,libmongoose.so", "-o", "libmongoose.so", "mongoose.o", "-lc", "-lpthread"
    end
    lib.install shared_library("libmongoose")
    include.install "mongoose.h"
    pkgshare.install "examples"
    doc.install Dir["docs/*"]
  end

  test do
    (testpath/"hello.html").write <<~EOS
      <!DOCTYPE html>
      <html>
        <head>
          <title>Homebrew</title>
        </head>
        <body>
          <p>Hi!</p>
        </body>
      </html>
    EOS

    begin
      pid = fork { exec "#{bin}/mongoose" }
      sleep 2
      assert_match "Hi!", shell_output("curl http://localhost:8000/hello.html")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
