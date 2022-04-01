class CargoInstruments < Formula
  desc "Easily generate Instruments traces for your rust crate"
  homepage "https://github.com/cmyr/cargo-instruments"
  url "https://github.com/cmyr/cargo-instruments/archive/v0.4.5.tar.gz"
  sha256 "aa7539badcca7ede2973face64f0daacfa8c76fac511d21397b9b6837c138cda"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cargo-instruments"
    sha256 cellar: :any, mojave: "c10f12f63f2e6b3b18809a40bb513d899427de0e35bddf575dd30c2f5224a8b7"
  end

  depends_on "rust" => :build
  depends_on :macos
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output "#{bin}/cargo-instruments instruments", 1
    assert_match output, "could not find `Cargo.toml` in `#{Dir.pwd}` or any parent directory"
  end
end
