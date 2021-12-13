class Proper < Formula
  desc "QuickCheck-inspired property-based testing tool for Erlang"
  homepage "https://proper-testing.github.io"
  url "https://github.com/proper-testing/proper/archive/v1.4.tar.gz"
  sha256 "38b14926f974c849fad74b031c25e32bf581974103e7a30ec2b325990fc32334"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/proper"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "3c561d528e58251f1e1aa18c8c64557eba75b933e1e83a540a5065108afdb853"
  end

  depends_on "rebar3" => :build
  depends_on "erlang"

  def install
    system "make"
    prefix.install Dir["_build/default/lib/proper/ebin", "include"]
    (prefix/"proper-#{version.major_minor}").install_symlink prefix/"ebin", include
  end

  def caveats
    <<~EOS
      To use PropEr in Erlang, you may need:
        export ERL_LIBS=#{opt_prefix}/proper-#{version.major_minor}
    EOS
  end

  test do
    output = shell_output("erl -noshell -pa #{opt_prefix}/ebin -eval 'io:write(code:which(proper))' -s init stop")
    refute_equal "non_existing", output
  end
end
