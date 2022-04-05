class Mask < Formula
  desc "CLI task runner defined by a simple markdown file"
  homepage "https://github.com/jakedeichert/mask/"
  url "https://github.com/jakedeichert/mask/archive/v0.11.1.tar.gz"
  sha256 "49de25ee23bfa2f04f09750cf9b223a8ff5024280dca4ea40893e53212bef0b0"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mask"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "54607b3276280b3ef273d96f32372a3307abf1576794470f58106b53e4f61415"
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
