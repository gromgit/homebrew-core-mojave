require "language/node"
class TerraformRover < Formula
  desc "Terraform Visualizer"
  homepage "https://github.com/im2nguyen/rover"
  url "https://github.com/im2nguyen/rover/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "91dc4ff26e0adafde011db1e6111a8a3c545cddbae1a70c8f4c3abc484b0be0b"
  license "MIT"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/terraform-rover"
    sha256 cellar: :any_skip_relocation, mojave: "42594e978a9ca73ef42aa066588f54a010c600e7635938c58ad0b600082b7453"
  end

  depends_on "go" => :build
  depends_on "node"
  depends_on "terraform"

  # Update terraform components, remove in next version
  patch do
    url "https://github.com/im2nguyen/rover/commit/a2a1e57ffcbedcc9a8d39c2696d4cee84eec8cd6.patch?full_index=1"
    sha256 "d085834625def68e9ebaaee89a6d077fba12220df5347529412f82c9cc69d7cd"
  end

  def install
    Language::Node.setup_npm_environment
    cd "ui" do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "build"
    end
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"main.tf").write <<~EOS
      output "hello_world" {
        value = "Hello, World!"
      }
    EOS
    system bin/"terraform-rover", "-standalone", "-tfPath", Formula["terraform"].bin/"terraform"
    assert_predicate testpath/"rover.zip", :exist?
  end
end
