class CargoOutdated < Formula
  desc "Cargo subcommand for displaying when Rust dependencies are out of date"
  homepage "https://github.com/kbknapp/cargo-outdated"
  url "https://github.com/kbknapp/cargo-outdated/archive/v0.11.0.tar.gz"
  sha256 "203504d8f7aa6ba633e256b6f9d81162dd1f3ddbf92934ff689060ae80b6b203"
  license "MIT"
  revision 1
  head "https://github.com/kbknapp/cargo-outdated.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cargo-outdated"
    sha256 cellar: :any, mojave: "90226bc738b70b93592ca73cfa60a1a6acaeae4c447ca49e4c04dd8e84c6c64c"
  end

  depends_on "libgit2"
  depends_on "openssl@1.1"
  depends_on "rust"

  # Workaround to patch cargo dependency tree for libgit2 issue
  # Issue ref: https://github.com/kbknapp/cargo-outdated/issues/307
  # Issue ref: https://github.com/rust-lang/cargo/issues/10446
  # TODO: Remove when issue is fixed and in release
  resource "cargo" do
    url "https://github.com/rust-lang/cargo/archive/0.60.0.tar.gz"
    sha256 "96dfa69407e9c5493c0858aab1d89e8f8bad992ab9ee1f83f2c55f6c7fc3686a"

    patch do
      url "https://github.com/rust-lang/cargo/commit/e756c130cf8b6348278db30bcd882a7f310cf58e.patch?full_index=1"
      sha256 "fc3caa41c01182f62f173543f0230349a23e37af05bed0a34ceb2bb5ce5ab6f7"
    end
  end

  # Fix issue with libgit2 >= 1.4 and git2-rs < 0.14.
  # Issue ref: https://github.com/kbknapp/cargo-outdated/issues/307
  # Issue ref: https://github.com/rust-lang/git2-rs/issues/813
  # TODO: Remove when issue is fixed and in release
  patch :DATA

  def install
    # TODO: Remove locally patched `cargo` when issue is fixed and in release
    (buildpath/"vendor/cargo").install resource("cargo")

    system "cargo", "install", *std_cargo_args
  end

  test do
    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [lib]
        path = "lib.rs"

        [dependencies]
        libc = "0.1"
      EOS

      (crate/"lib.rs").write "use libc;"

      output = shell_output("cargo outdated 2>&1")
      # libc 0.1 is outdated
      assert_match "libc", output
    end
  end
end

__END__
diff --git a/Cargo.toml b/Cargo.toml
index 2ce0c82..a2f5274 100644
--- a/Cargo.toml
+++ b/Cargo.toml
@@ -31,7 +31,7 @@ name = "cargo-outdated"
 anyhow = "1.0"
 cargo = "0.60.0"
 env_logger = "0.9.0"
-git2-curl = "0.14.0"
+git2-curl = "0.15.0"
 semver = "1.0.0"
 serde = {version="1.0.114", features = ["derive"]}
 serde_derive = "1.0.114"
@@ -41,6 +41,9 @@ tempfile = "3"
 toml = "~0.5.0"
 clap = "2.33.3"

+[patch.crates-io]
+cargo = { path = "vendor/cargo" }
+
 [dependencies.termcolor]
 optional = true
 version = "1.0"
