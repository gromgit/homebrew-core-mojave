class Corral < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/corral"
  url "https://github.com/ponylang/corral/archive/0.5.7.tar.gz"
  sha256 "5b7cffc54abe5b2292a2fb2c67603a52c0c02d38ab8bbd2af2af0b80ca62e414"
  license "BSD-2-Clause"
  head "https://github.com/ponylang/corral.git", branch: "main"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/corral"
    sha256 cellar: :any_skip_relocation, mojave: "9304705afb4e5cb831882a716f44e77383c4824e13448d7e7ff2dda2c906e487"
  end

  depends_on "ponyc"

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/"test/main.pony").write <<~EOS
      actor Main
        new create(env: Env) =>
          env.out.print("Hello World!")
    EOS
    system "#{bin}/corral", "run", "--", "ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").chomp
  end
end
