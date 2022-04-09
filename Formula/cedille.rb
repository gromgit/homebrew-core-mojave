class Cedille < Formula
  desc "Language based on the Calculus of Dependent Lambda Eliminations"
  homepage "https://cedille.github.io/"
  url "https://github.com/cedille/cedille.git",
      tag:      "v1.1.2",
      revision: "4d8a343a8d3f0b318e3c1b3209d216912dbc06ee"
  license "MIT"
  revision 4
  head "https://github.com/cedille/cedille.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cedille"
    sha256 cellar: :any, mojave: "ea547d9790f5d2841f2394c23cb8b30a751224e01bdbb396d70efea0853344b8"
  end

  depends_on "haskell-stack" => :build
  depends_on "ghc"

  # needed to build with agda 2.6.1
  # taken from https://github.com/cedille/cedille/pull/144/files
  # but added at the bottom to apply cleanly on v1.1.2
  # remove once this is merged into cedille, AND formula updated to
  # a release that contains it
  patch :DATA

  def install
    inreplace "stack.yaml", "resolver: lts-12.26", <<~EOS
      resolver: lts-16.12
      compiler: ghc-#{Formula["ghc"].version}
      compiler-check: newer-minor
      allow-newer: true
      system-ghc: true
      install-ghc: false
    EOS

    # Build fails with agda >= 2.6.2, so locally install agda 2.6.1.
    # Issue ref: https://github.com/cedille/cedille/issues/162
    # TODO: on next release, switch to `depends_on "agda"` if supported,
    # or reduce list to `Agda alex happy` once stack.yaml includes extra-deps.
    deps = %w[
      Agda-2.6.1.3
      alex
      happy
      data-hash-0.2.0.1
      equivalence-0.3.5
      geniplate-mirror-0.7.8
      STMonadTrans-0.4.6
    ]
    system "stack", "build", "--copy-bins", "--local-bin-path=#{buildpath}/bin", *deps
    ENV.append_path "PATH", buildpath/"bin"

    system "stack", "build", "--copy-bins", "--local-bin-path=#{bin}"

    system "make", "core/cedille-core"

    # binaries and elisp
    bin.install "core/cedille-core"
    elisp.install "cedille-mode.el", "cedille-mode", "se-mode"

    # standard libraries
    (lib/"cedille").install "lib", "new-lib"

    # documentation
    doc.install Dir["docs/html/*"]
    (doc/"semantics").install "docs/semantics/paper.pdf"
    info.install "docs/info/cedille-info-main.info"
  end

  test do
    coretest = testpath/"core-test.ced"
    coretest.write <<~EOS
      module core-test.

      id = Λ X: ★. λ x: X. x.

      cNat : ★ = ∀ X: ★. Π _: X. Π _: Π _: X. X. X.
      czero = Λ X: ★. λ x: X. λ f: Π _: X. X. x.
      csucc = λ n: cNat. Λ X: ★. λ x: X. λ f: Π _: X. X. f (n ·X x f).

      iNat : Π n: cNat. ★
        = λ n: cNat. ∀ P: Π _: cNat. ★.
          Π _: P czero. Π _: ∀ n: cNat. Π p: P n. P (csucc n). P n.
      izero
        = Λ P: Π _: cNat. ★.
          λ base: P czero. λ step: ∀ n: cNat. Π p: P n. P (csucc n). base.
      isucc
        = Λ n: cNat. λ i: iNat n. Λ P: Π _: cNat. ★.
          λ base: P czero. λ step: ∀ n: cNat. Π p: P n. P (csucc n).
            step -n (i ·P base step).

      Nat : ★ = ι x: cNat. iNat x.
      zero = [ czero, izero @ x. iNat x ].
      succ = λ n: Nat. [ csucc n.1, isucc -n.1 n.2 @x. iNat x ].
    EOS

    cedilletest = testpath/"cedille-test.ced"
    cedilletest.write <<~EOS
      module cedille-test.

      id : ∀ X: ★. X ➔ X = Λ X. λ x. x.

      cNat : ★ = ∀ X: ★. X ➔ (X ➔ X) ➔ X.
      czero : cNat = Λ X. λ x. λ f. x.
      csucc : cNat ➔ cNat = λ n. Λ X. λ x. λ f. f (n x f).

      iNat : cNat ➔ ★
        = λ n: cNat. ∀ P: cNat ➔ ★.
          P czero ➔ (∀ n: cNat. P n ➔ P (csucc n)) ➔ P n.
      izero : iNat czero = Λ P. λ base. λ step. base.
      isucc : ∀ n: cNat. iNat n ➔ iNat (csucc n)
        = Λ n. λ i. Λ P. λ base. λ step. step -n (i base step).

      Nat : ★ = ι n: cNat. iNat n.
      zero : Nat = [ czero, izero ].
      succ : Nat ➔ Nat = λ n. [ csucc n.1, isucc -n.1 n.2 ].
    EOS

    # test cedille-core
    system bin/"cedille-core", coretest

    # test cedille
    system bin/"cedille", cedilletest
  end
end

__END__
diff --git a/src/to-string.agda b/src/to-string.agda
index 2505942..051a2da 100644
--- a/src/to-string.agda
+++ b/src/to-string.agda
@@ -100,9 +100,9 @@ no-parens {TK} _ _ _ = tt
 no-parens {QUALIF} _ _ _ = tt
 no-parens {ARG} _ _ _ = tt

-pattern ced-ops-drop-spine = cedille-options.options.mk-options _ _ _ _ ff _ _ _ ff _
-pattern ced-ops-conv-arr = cedille-options.options.mk-options _ _ _ _ _ _ _ _ ff _
-pattern ced-ops-conv-abs = cedille-options.options.mk-options _ _ _ _ _ _ _ _ tt _
+pattern ced-ops-drop-spine = cedille-options.mk-options _ _ _ _ ff _ _ _ ff _
+pattern ced-ops-conv-arr = cedille-options.mk-options _ _ _ _ _ _ _ _ ff _
+pattern ced-ops-conv-abs = cedille-options.mk-options _ _ _ _ _ _ _ _ tt _

 drop-spine : cedille-options.options → {ed : exprd} → ctxt → ⟦ ed ⟧ → ⟦ ed ⟧
 drop-spine ops @ ced-ops-drop-spine = h
