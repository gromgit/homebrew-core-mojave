class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https://github.com/dlang-community/dfmt"
  url "https://github.com/dlang-community/dfmt.git",
      tag:      "v0.14.2",
      revision: "6a24f0dc7c490f4cb06cdc9d21b841bee84615f4"
  license "BSL-1.0"
  head "https://github.com/dlang-community/dfmt.git", branch: "v0.x.x"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dfmt"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "3f9b4cb4016263f8a789ee570b78eb3761070e518272b29deb82933a6ef283ca"
  end

  on_macos do
    depends_on "ldc" => :build
  end

  on_linux do
    depends_on "dmd" => :build
  end

  def install
    target = OS.mac? ? "ldc" : "dmd"
    system "make", target
    bin.install "bin/dfmt"
  end

  test do
    (testpath/"test.d").write <<~EOS
      import std.stdio; void main() { writeln("Hello, world without explicit compilations!"); }
    EOS

    expected = <<~EOS
      import std.stdio;

      void main()
      {
          writeln("Hello, world without explicit compilations!");
      }
    EOS

    system "#{bin}/dfmt", "-i", "test.d"

    assert_equal expected, (testpath/"test.d").read
  end
end
