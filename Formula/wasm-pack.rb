class WasmPack < Formula
  desc "Your favorite rust -> wasm workflow tool!"
  homepage "https://rustwasm.github.io/wasm-pack/"
  url "https://github.com/rustwasm/wasm-pack/archive/v0.10.3.tar.gz"
  sha256 "a4596c08dca32e2f0a1bfe1215421981943b66977846b573c13ea4a7e71fc94c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rustwasm/wasm-pack.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/wasm-pack"
    sha256 cellar: :any_skip_relocation, mojave: "3f1a2aed6878328dd9e7f80fa990547a2fd27a7e6d19ca3cbd65b9681096440f"
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
