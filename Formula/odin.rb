class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin.git",
      tag:      "dev-2022-08",
      revision: "73beed0477936ee5b64b9b02f8fa7e399c623c8b"
  version "2022-08"
  license "BSD-3-Clause"
  head "https://github.com/odin-lang/Odin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "05ecd553e5ee0bd46862767c710c1e3a1d86ea2f779d017a6b313df44065326c"
    sha256 cellar: :any,                 arm64_big_sur:  "e04e6af571209fc7ad4ce0742d566cd05429ece4854bdd948f9e6501238ef3aa"
    sha256 cellar: :any,                 monterey:       "2c25e6a641ca1dc958efc9b7fd38a691a23dce445d149bcef733f8fa9a807736"
    sha256 cellar: :any,                 big_sur:        "94b4944a4efa7b65fa14323380056a44e9f8cfb8b601ed0a86ed2c6ec810b491"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b4b160be6f48d88ce3dd283e3059ca95bf1786d339652b3a872e8508e513395"
  end

  depends_on "llvm"
  # Build failure on macOS 10.15 due to `__ulock_wait2` usage.
  # Issue ref: https://github.com/odin-lang/Odin/issues/1773
  depends_on macos: :big_sur

  fails_with gcc: "5" # LLVM is built with GCC

  def install
    # Keep version number consistent and reproducible for tagged releases.
    # Issue ref: https://github.com/odin-lang/Odin/issues/1772
    inreplace "build_odin.sh", "dev-$(date +\"%Y-%m\")", "dev-#{version}" unless build.head?

    system "make", "release"
    libexec.install "odin", "core", "shared"
    (bin/"odin").write <<~EOS
      #!/bin/bash
      export PATH="#{Formula["llvm"].opt_bin}:$PATH"
      exec -a odin "#{libexec}/odin" "$@"
    EOS
    pkgshare.install "examples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/odin version")

    (testpath/"hellope.odin").write <<~EOS
      package main

      import "core:fmt"

      main :: proc() {
        fmt.println("Hellope!");
      }
    EOS
    system "#{bin}/odin", "build", "hellope.odin", "-file"
    assert_equal "Hellope!\n", shell_output("./hellope.bin")
  end
end
