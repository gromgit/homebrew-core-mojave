class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.14.0.tar.gz"
  sha256 "ac129e266a1e04cdc389551843ec3dbdf36086bb2174d3d7e7936e820735003b"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/elixir"
    sha256 cellar: :any_skip_relocation, mojave: "592ffc7854e7016d0785da30b9067905b00bce87f8d69effeb0083fdff7b512e"
  end

  depends_on "erlang"

  def install
    system "make"
    bin.install Dir["bin/*"] - Dir["bin/*.{bat,ps1}"]

    Dir.glob("lib/*/ebin") do |path|
      app = File.basename(File.dirname(path))
      (lib/app).install path
    end

    system "make", "install_man", "PREFIX=#{prefix}"
  end

  test do
    assert_match(%r{(compiled with Erlang/OTP 25)}, shell_output("#{bin}/elixir -v"))
  end
end
