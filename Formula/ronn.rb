class Ronn < Formula
  desc "Builds manuals - the opposite of roff"
  homepage "https://rtomayko.github.io/ronn/"
  url "https://github.com/rtomayko/ronn/archive/0.7.3.tar.gz"
  sha256 "808aa6668f636ce03abba99c53c2005cef559a5099f6b40bf2c7aad8e273acb4"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ronn"
    sha256 mojave: "22530381062c6b4a04a8f68441f091c20f89212ad0d8d26c95859a50dccf56fd"
  end

  depends_on "groff" => :test

  uses_from_macos "ruby"

  on_linux do
    depends_on "util-linux" => :test # for `col`
  end

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "ronn.gemspec"
    system "gem", "install", "ronn-#{version}.gem"
    bin.install libexec/"bin/ronn"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
    man1.install "man/ronn.1"
    man7.install "man/ronn-format.7"
  end

  test do
    (testpath/"test.ronn").write <<~EOS
      simple(7) -- a simple ronn example
      ==================================

      This document is created by ronn.
    EOS
    system bin/"ronn", "--date", "1970-01-01", "test.ronn"
    assert_equal <<~EOS, pipe_output("col -bx", shell_output("groff -t -man -Tascii test.7"))
      SIMPLE(7)                                                            SIMPLE(7)



      1mNAME0m
             1msimple 22m- a simple ronn example

             This document is created by ronn.



                                       January 1970                        SIMPLE(7)
    EOS
  end
end
