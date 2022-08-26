require "language/node"
class TerraformRover < Formula
  desc "Terraform Visualizer"
  homepage "https://github.com/im2nguyen/rover"
  url "https://github.com/im2nguyen/rover/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "491709df11c70c9756e55f4cd203321bf1c6b92793b8db91073012a1f13b42e5"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/terraform-rover"
    sha256 cellar: :any_skip_relocation, mojave: "956a2d370e670e763f61f5ba9238eae1beb7c1573bc16a9f690788989c6450a7"
  end

  depends_on "go" => :build
  depends_on "node"
  depends_on "terraform"

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
