class Forego < Formula
  desc "Foreman in Go for Procfile-based application management"
  homepage "https://github.com/ddollar/forego"
  url "https://github.com/ddollar/forego/archive/20180216151118.tar.gz"
  sha256 "23119550cc0e45191495823aebe28b42291db6de89932442326340042359b43d"
  license "Apache-2.0"
  head "https://github.com/ddollar/forego.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/forego"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "c61d006b84a9f2e05576626f127a956ac2090ebbe1bc654fb5ad6254d8664693"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "off"
    (buildpath/"src/github.com/ddollar/forego").install buildpath.children
    cd "src/github.com/ddollar/forego" do
      system "go", "build", "-o", bin/"forego", "-ldflags",
             "-X main.Version=#{version} -X main.allowUpdate=false"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"Procfile").write "web: echo \"it works!\""
    assert_match "it works", shell_output("#{bin}/forego start")
  end
end
