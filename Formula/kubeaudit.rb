class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/refs/tags/0.16.0.tar.gz"
  sha256 "1f1c21352a5788586e5903dee499668d45318fb388b0cc3860b1a0d09bb489fc"
  license "MIT"
  head "https://github.com/Shopify/kubeaudit.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kubeaudit"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "1ea6498f62eadc1e3aa489eb88ed645fe9fd38609f1719cdb1bd31ff0456c7f0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Shopify/kubeaudit/cmd.Version=#{version}
      -X github.com/Shopify/kubeaudit/cmd.BuildDate=#{time.strftime("%F")}
    ]

    system "go", "build", "-ldflags", ldflags.join(" "), *std_go_args, "./cmd"
  end

  test do
    output = shell_output(bin/"kubeaudit -c /some-file-that-does-not-exist all 2>&1", 1).chomp
    assert_match "failed to open kubeconfig file /some-file-that-does-not-exist", output
  end
end
