class Popeye < Formula
  desc "Kubernetes cluster resource sanitizer"
  homepage "https://popeyecli.io"
  url "https://github.com/derailed/popeye/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "6dba28376f3016e49a597d1bb3b9365cdd5ba5cd6e21c848e1c97dca49d6bdaf"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/popeye"
    sha256 cellar: :any_skip_relocation, mojave: "25f9f1a826004bd19f0df24a5adbd03dffa0501eafdfea21f9b74c90ad592dc3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"popeye", "completion")
  end

  test do
    assert_match "connect: connection refused",
      shell_output("#{bin}/popeye --save --out html --output-file report.html", 1)
  end
end
