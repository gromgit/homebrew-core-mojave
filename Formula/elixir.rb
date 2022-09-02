class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.13.4.tar.gz"
  sha256 "95daf2dd3052e6ca7d4d849457eaaba09de52d65ca38d6933c65bc1cdf6b8579"
  license "Apache-2.0"
  revision 1
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/elixir"
    sha256 cellar: :any_skip_relocation, mojave: "86f390fc17e4d65b186f09c9aa383b258cdd5a25d112f4505e8739fbbcf68929"
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
