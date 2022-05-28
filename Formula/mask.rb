class Mask < Formula
  desc "CLI task runner defined by a simple markdown file"
  homepage "https://github.com/jakedeichert/mask/"
  url "https://github.com/jacobdeichert/mask/archive/v0.11.2.tar.gz"
  sha256 "abe5fddc7ea1a1ffab59c8f0823a95c7a6fdcfe86749f816b06d7690319d56aa"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mask"
    sha256 cellar: :any_skip_relocation, mojave: "91331c82c1862c2beab271237d2b436976141cbaff9f08effcfd22e65221522c"
  end

  depends_on "rust" => :build

  def install
    cd "mask" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"maskfile.md").write <<~EOS
      # Example maskfile

      ## hello (name)

      ```sh
      printf "Hello %s!" "$name"
      ```
    EOS
    assert_equal "Hello Homebrew!", shell_output("#{bin}/mask hello Homebrew")
  end
end
