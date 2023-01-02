class Dockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/jwilder/dockerize"
  url "https://github.com/jwilder/dockerize/archive/v0.6.1.tar.gz"
  sha256 "c21cea3e6bb33a2e280c28d3521b8f177c78e875b475763fcb9bd7a545e21688"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dockerize"
    rebuild 3
    sha256 cellar: :any_skip_relocation, mojave: "9ffe7879861474c280da26768427ba070084abe9072dcaec16d1b3aa56a7e0eb"
  end

  depends_on "go" => :build
  conflicts_with "powerman-dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/jwilder/dockerize").install buildpath.children
    ENV.append_path "PATH", buildpath/"bin"

    cd "src/github.com/jwilder/dockerize" do
      system "make", "deps"
      system "go", "build", *std_go_args(ldflags: "-s -w -X main.buildVersion=#{version}")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system "#{bin}/dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
