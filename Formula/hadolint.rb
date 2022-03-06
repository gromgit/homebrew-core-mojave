class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v2.8.0.tar.gz"
  sha256 "b02250cfa6c1581cfa38f425ed9a0b791ce7217b688e575d74fb81dcae9b21ac"
  license "GPL-3.0-only"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hadolint"
    rebuild 4
    sha256 cellar: :any_skip_relocation, mojave: "2a0ffbd336542549204e978169da0b192e410cc086e005c2b427e6a1e24eaee1"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "xz"

  def install
    # Let `stack` handle its own parallelization
    jobs = ENV.make_jobs
    ENV.deparallelize

    ghc_args = [
      "--system-ghc",
      "--no-install-ghc",
      "--skip-ghc-check",
    ]

    system "stack", "-j#{jobs}", "build", *ghc_args
    system "stack", "-j#{jobs}", "--local-bin-path=#{bin}", "install", *ghc_args
  end

  test do
    df = testpath/"Dockerfile"
    df.write <<~EOS
      FROM debian
    EOS
    assert_match "DL3006", shell_output("#{bin}/hadolint #{df}", 1)
  end
end
