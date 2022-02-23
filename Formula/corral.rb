class Corral < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/corral"
  url "https://github.com/ponylang/corral/archive/0.5.6.tar.gz"
  sha256 "2622486e794024fd06d0b6426b049c2e91e9be72b03494ff740e3ea49d4fe265"
  license "BSD-2-Clause"
  head "https://github.com/ponylang/corral.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/corral"
    sha256 cellar: :any_skip_relocation, mojave: "eb10af264037c7187f395d822bfb23c547907b5984b1d801186dc516e89037ac"
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
