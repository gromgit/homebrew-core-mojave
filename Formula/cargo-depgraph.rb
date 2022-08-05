class CargoDepgraph < Formula
  desc "Creates dependency graphs for cargo projects"
  homepage "https://sr.ht/~jplatte/cargo-depgraph/"
  url "https://git.sr.ht/~jplatte/cargo-depgraph/archive/v1.2.5.tar.gz"
  sha256 "75e6b716996062518bc556607929abce52dffdd97422275b41079e971f9459e2"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cargo-depgraph"
    sha256 cellar: :any_skip_relocation, mojave: "c58628f53045a7d6358c883688290e710f706f788cd4b8b2f2054d3911593d49"
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
