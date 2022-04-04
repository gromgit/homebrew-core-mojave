class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/refs/tags/0.16.0.tar.gz"
  sha256 "1f1c21352a5788586e5903dee499668d45318fb388b0cc3860b1a0d09bb489fc"
  license "MIT"
  head "https://github.com/Shopify/kubeaudit.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kubeaudit"
    rebuild 3
    sha256 cellar: :any_skip_relocation, mojave: "d26d706a15448c612fc5820634ca3932b6831cbd8db1e475b13f872b26a11799"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Shopify/kubeaudit/cmd.Version=#{version}
      -X github.com/Shopify/kubeaudit/cmd.BuildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd"
  end

  test do
    output = shell_output(bin/"kubeaudit -c /some-file-that-does-not-exist all 2>&1", 1).chomp
    assert_match "failed to open kubeconfig file /some-file-that-does-not-exist", output
  end
end
