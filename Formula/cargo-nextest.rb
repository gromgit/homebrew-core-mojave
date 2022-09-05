class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.35.tar.gz"
  sha256 "24ed1d3d098ede98fbbcefe9dee7f223ba81ab8a52eb6361018cf03cd70e4d59"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cargo-nextest"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "4f31cba30ff67c60ec82f505d329654324067c4ec3c877e16bef66579d84ed4e"
  end

  depends_on "rust" # uses `cargo` at runtime

  def install
    # Fix a performance regression. This can be removed once Rust 1.64 is stable.
    # See https://github.com/nextest-rs/nextest/releases/tag/cargo-nextest-0.9.30
    ENV["RUSTC_BOOTSTRAP"] = "1"
    ENV["RUSTFLAGS"] = "--cfg process_group --cfg process_group_bootstrap_hack"
    system "cargo", "install", "--no-default-features", "--features", "default-no-update",
                    *std_cargo_args(path: "cargo-nextest")
  end

  test do
    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~EOS
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      EOS
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"
      EOS

      output = shell_output("cargo nextest run 2>&1")
      assert_match "Starting 1 tests across 1 binaries", output
    end
  end
end
