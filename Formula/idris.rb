class Idris < Formula
  desc "Pure functional programming language with dependent types"
  homepage "https://www.idris-lang.org/"
  url "https://github.com/idris-lang/Idris-dev/archive/v1.3.4.tar.gz"
  sha256 "7289f5e2501b7a543d81035252ca9714003f834f58b558f45a16427a3c926c0f"
  license "BSD-3-Clause"
  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/idris"
    rebuild 2
    sha256 mojave: "bd0ffb6f12e31773c0a893c1cc111cc7c8014db694cbedceff515c814d8d8f23"
  end

  depends_on "cabal-install" => :build
  depends_on "pkg-config" => :build
  depends_on "ghc@8.8"
  depends_on "libffi"

  def install
    system "cabal", "v2-update"
    system "cabal", "--storedir=#{libexec}", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"hello.idr").write <<~EOS
      module Main
      main : IO ()
      main = putStrLn "Hello, Homebrew!"
    EOS

    system bin/"idris", "hello.idr", "-o", "hello"
    assert_equal "Hello, Homebrew!", shell_output("./hello").chomp

    (testpath/"ffi.idr").write <<~EOS
      module Main
      puts: String -> IO ()
      puts x = foreign FFI_C "puts" (String -> IO ()) x
      main : IO ()
      main = puts "Hello, interpreter!"
    EOS

    system bin/"idris", "ffi.idr", "-o", "ffi"
    assert_equal "Hello, interpreter!", shell_output("./ffi").chomp
  end
end
