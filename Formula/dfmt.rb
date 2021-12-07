class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https://github.com/dlang-community/dfmt"
  url "https://github.com/dlang-community/dfmt.git",
      tag:      "v0.14.1",
      revision: "b776d5a9b96df283ab93b19a9bc689d633bdcb83"
  license "BSL-1.0"
  head "https://github.com/dlang-community/dfmt.git", branch: "v0.x.x"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dfmt"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "20680deb3198c279fa5e44e9040f6ffe6da6d5ba2cd3060372765e92fc954f46"
  end

  depends_on "dmd" => :build

  def install
    system "make"
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
