class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.13.3.tar.gz"
  sha256 "652779f7199f5524e2df1747de0e373d8b9f1d1206df25b2e551cd0ad33f8440"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/elixir"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "5b85495a3ac4bb5c70b1211d4b96037625b0e0ae7aa998b369a8f57469152198"
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
