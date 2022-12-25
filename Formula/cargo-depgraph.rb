class CargoDepgraph < Formula
  desc "Creates dependency graphs for cargo projects"
  homepage "https://sr.ht/~jplatte/cargo-depgraph/"
  url "https://git.sr.ht/~jplatte/cargo-depgraph/archive/v1.4.0.tar.gz"
  sha256 "c138718e610673352b99d7078eda46f6039c3e20d44f85e4312d48d9dce99f77"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cargo-depgraph"
    sha256 cellar: :any_skip_relocation, mojave: "e0a807f432550755a438e749f10bdda6d53c353c426f40b0bdeafcbe9b58834b"
  end

  depends_on "rust" => [:build, :test]

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write "// Dummy file"
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [dependencies]
        rustc-std-workspace-core = "1.0.0" # explicitly empty crate for testing
      EOS
      expected = <<~EOS
        digraph {
            0 [ label = "demo-crate" shape = box]
            1 [ label = "rustc-std-workspace-core" ]
            0 -> 1 [ ]
        }

      EOS
      output = shell_output("#{bin}/cargo-depgraph depgraph")
      assert_equal expected, output
    end
  end
end
