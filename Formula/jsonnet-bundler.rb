class JsonnetBundler < Formula
  desc "Package manager for Jsonnet"
  homepage "https://github.com/jsonnet-bundler/jsonnet-bundler"
  url "https://github.com/jsonnet-bundler/jsonnet-bundler.git",
      tag:      "v0.5.1",
      revision: "451a33c1c1f6950bc3a7d25353e35bed1b983370"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jsonnet-bundler"
    sha256 cellar: :any_skip_relocation, mojave: "5375aed94a94a675565224695b95426ed721239d1fca8bfa223d76e0b113adfb"
  end

  depends_on "go" => :build

  def install
    system "make", "static"
    bin.install "_output/jb"
  end

  test do
    assert_match "A jsonnet package manager", shell_output("#{bin}/jb 2>&1")

    system bin/"jb", "init"
    assert_predicate testpath/"jsonnetfile.json", :exist?

    system bin/"jb", "install", "https://github.com/grafana/grafonnet-lib"
    assert_predicate testpath/"vendor", :directory?
    assert_predicate testpath/"jsonnetfile.lock.json", :exist?
  end
end
