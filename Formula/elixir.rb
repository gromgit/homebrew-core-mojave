class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.13.0.tar.gz"
  sha256 "0ed0fb89a9b6428cd1537b7f9aab1d6ea64e0c5972589eeb46dff6f0324468ae"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/elixir"
    sha256 cellar: :any_skip_relocation, mojave: "c537a781f7558eae75a85e092cccfcdb426a100177fbd84f1672364528e815fb"
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
