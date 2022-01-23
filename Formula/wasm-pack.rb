class WasmPack < Formula
  desc "Your favorite rust -> wasm workflow tool!"
  homepage "https://rustwasm.github.io/wasm-pack/"
  url "https://github.com/rustwasm/wasm-pack/archive/v0.10.2.tar.gz"
  sha256 "533b7f63c04411e5d771d406b1c56134e3045b48fb1673985ad8fed1bc937517"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rustwasm/wasm-pack.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/wasm-pack"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "8ce380a27f1b12536f36dc8aaf82ea654260f921cdf3e59a8a30aae72bf78412"
  end

  depends_on "rust" => :build
  depends_on "rustup-init"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "wasm-pack #{version}", shell_output("#{bin}/wasm-pack --version")

    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    system bin/"wasm-pack", "new", "hello-wasm"
    system bin/"wasm-pack", "build", "hello-wasm"
    assert_predicate testpath/"hello-wasm/pkg/hello_wasm_bg.wasm", :exist?
  end
end
