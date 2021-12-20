class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.13.1.tar.gz"
  sha256 "deaba8156b11777adfa28e54e76ddf49ab1a0132cca54c41d9d7648e800edcc8"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/elixir"
    sha256 cellar: :any_skip_relocation, mojave: "d764cde64fb096cafdc0f5c7400f4c090051d65dbe8f0c1b8cf9937cf46f478f"
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
    system "#{bin}/elixir", "-v"
  end
end
