class ElanInit < Formula
  desc "Lean Theorem Prover installer and version manager"
  homepage "https://github.com/leanprover/elan"
  url "https://github.com/leanprover/elan/archive/v1.4.2.tar.gz"
  sha256 "d15dc93575601224b73c4744c27f28cb118655659b20d444e93ed63ba30b7def"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/leanprover/elan.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/elan-init"
    sha256 cellar: :any_skip_relocation, mojave: "5f1368e711d3e134e0b81666b15294401ec7d2f920d65adc70bfbdb5d97e6ece"
  end

  depends_on "rust" => :build
  # elan-init will run on arm64 Macs, but will fetch Leans that are x86_64.
  depends_on arch: :x86_64
  depends_on "coreutils"
  depends_on "gmp"

  uses_from_macos "zlib"

  conflicts_with "lean", because: "`lean` and `elan-init` install the same binaries"

  def install
    ENV["RELEASE_TARGET_NAME"] = "homebrew-build"

    system "cargo", "install", "--features", "no-self-update", *std_cargo_args

    %w[lean leanpkg leanchecker leanc leanmake lake elan].each do |link|
      bin.install_symlink "elan-init" => link
    end

    generate_completions_from_executable(bin/"elan", "completions", base_name: "elan")
  end

  test do
    system bin/"elan-init", "-y"
    (testpath/"hello.lean").write <<~EOS
      def id' {α : Type} (x : α) : α := x

      inductive tree (α : Type) : Type
      | node : α → list tree → tree

      example (a b : Prop) : a ∧ b -> b ∧ a :=
      begin
          intro h, cases h,
          split, repeat { assumption }
      end
    EOS
    system bin/"lean", testpath/"hello.lean"
    system bin/"leanpkg", "help"
  end
end
