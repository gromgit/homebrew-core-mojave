class Landscaper < Formula
  desc "Manage the application landscape in a Kubernetes cluster"
  homepage "https://github.com/Eneco/landscaper"
  url "https://github.com/Eneco/landscaper.git",
      tag:      "v1.0.24",
      revision: "1199b098bcabc729c885007d868f38b2cf8d2370"
  license "Apache-2.0"
  revision 1
  head "https://github.com/Eneco/landscaper.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/landscaper"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "bc48828d86e059e6549904291365fb00f5e356f939808710e462f530bf263134"
  end

  # also depends on helm@2 (which failed to build)
  deprecate! date: "2020-04-22", because: :repo_archived

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "helm@2"
  depends_on "kubernetes-cli"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    ENV.prepend_create_path "PATH", buildpath/"bin"
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    ENV["TARGETS"] = "#{OS.kernel_name.downcase}/#{arch}"
    dir = buildpath/"src/github.com/eneco/landscaper"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "make", "bootstrap"
      system "make", "build"
      bin.install "build/landscaper"
      bin.env_script_all_files(libexec/"bin", PATH: "#{Formula["helm@2"].opt_bin}:$PATH")
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/landscaper apply --dry-run 2>&1", 1)
    assert_match "This is Landscaper v#{version}", output
    assert_match "dryRun=true", output
  end
end
