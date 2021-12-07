class ElanInit < Formula
  desc "Lean Theorem Prover installer and version manager"
  homepage "https://github.com/leanprover/elan"
  url "https://github.com/leanprover/elan/archive/v1.3.1.tar.gz"
  sha256 "8e1380a1cb20cec54f07e30519ad7bc0179d9e3d68d33c02d0476248322b5015"
  license "Apache-2.0"
  head "https://github.com/leanprover/elan.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/elan-init"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "c06f56a630ed8b2664d60c3fbda7c035b560ba36c9fd6429444d5980ee1d4dbf"
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

    bash_output = Utils.safe_popen_read(bin/"elan", "completions", "bash")
    (bash_completion/"elan").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"elan", "completions", "zsh")
    (zsh_completion/"_elan").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"elan", "completions", "fish")
    (fish_completion/"elan.fish").write fish_output
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
