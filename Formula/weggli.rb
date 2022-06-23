class Weggli < Formula
  desc "Fast and robust semantic search tool for C and C++ codebases"
  homepage "https://github.com/googleprojectzero/weggli"
  url "https://github.com/googleprojectzero/weggli/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "12fde9a0dca2852d5f819eeb9de85c4d11c5c384822f93ac66b2b7b166c3af78"
  license "Apache-2.0"
  head "https://github.com/googleprojectzero/weggli.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/weggli"
    sha256 cellar: :any_skip_relocation, mojave: "3757c1ea022f117cb78150295aa99527ffd9048dcf837e589251b9c9225508f7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.c").write("void foo() {int bar=10+foo+bar;}")
    system "#{bin}/weggli", "{int $a = _+foo+$a;}", testpath/"test.c"
  end
end
