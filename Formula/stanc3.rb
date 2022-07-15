class Stanc3 < Formula
  desc "Stan transpiler"
  homepage "https://github.com/stan-dev/stanc3"
  # git is needed for dune subst
  url "https://github.com/stan-dev/stanc3.git",
      tag:      "v2.30.0",
      revision: "4b398e851b38e83573287c4e52a46406e293540e"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/stanc3"
    sha256 cellar: :any_skip_relocation, mojave: "eb23c4b7014b37ab997adf559eeefa17d1e75e19a5f77865fc086ace1db17372"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "unzip" => :build

  def install
    Dir.mktmpdir("opamroot") do |opamroot|
      ENV["OPAMROOT"] = opamroot
      ENV["OPAMYES"] = "1"
      ENV["OPAMVERBOSE"] = "1"

      system "opam", "init", "--no-setup", "--disable-sandboxing"
      system "bash", "-x", "scripts/install_build_deps.sh"
      system "opam", "exec", "dune", "subst"
      system "opam", "exec", "dune", "build", "@install"

      bin.install "_build/default/src/stanc/stanc.exe" => "stanc"
      pkgshare.install "test"
    end
  end

  test do
    assert_match "stanc3 v#{version}", shell_output("#{bin}/stanc --version")

    cp pkgshare/"test/integration/good/algebra_solver_good.stan", testpath
    system bin/"stanc", "algebra_solver_good.stan"
    assert_predicate testpath/"algebra_solver_good.hpp", :exist?
  end
end
