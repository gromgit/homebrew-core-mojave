class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/kubecfg/kubecfg"
  url "https://github.com/kubecfg/kubecfg/archive/v0.27.0.tar.gz"
  sha256 "4fed9a09ee12fa2452becb9b64278444f99093d3044bc417aaa92ab3b5851d81"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kubecfg"
    sha256 cellar: :any_skip_relocation, mojave: "26f4c88caaeee1af0cc62ea7dbf72885ed38754be8d0556ada7b53e7c664e5ef"
  end

  depends_on "go" => :build

  def install
    (buildpath/"src/github.com/kubecfg/kubecfg").install buildpath.children

    cd "src/github.com/kubecfg/kubecfg" do
      system "make", "VERSION=v#{version}"
      bin.install "kubecfg"
      pkgshare.install Pathname("examples").children
      pkgshare.install Pathname("testdata").children
      prefix.install_metafiles
    end

    generate_completions_from_executable(bin/"kubecfg", "completion", "--shell", shells: [:bash, :zsh])
  end

  test do
    system bin/"kubecfg", "show", "--alpha", pkgshare/"kubecfg_test.jsonnet"
  end
end
