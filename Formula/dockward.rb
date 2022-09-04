require "language/go"

class Dockward < Formula
  desc "Port forwarding tool for Docker containers"
  homepage "https://github.com/abiosoft/dockward"
  url "https://github.com/abiosoft/dockward/archive/0.0.4.tar.gz"
  sha256 "b96244386ae58aefb16177837d7d6adf3a9e6d93b75eea3308a45eb8eb9f4116"
  license "Apache-2.0"
  head "https://github.com/abiosoft/dockward.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dockward"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "928cc2831d02942156e16a5f67376500c95a79a13a7834055b3cc3b289bc78d6"
  end

  depends_on "go" => :build

  go_resource "github.com/Sirupsen/logrus" do
    url "https://github.com/Sirupsen/logrus.git",
        revision: "61e43dc76f7ee59a82bdf3d71033dc12bea4c77d"
  end

  go_resource "github.com/docker/distribution" do
    url "https://github.com/docker/distribution.git",
        revision: "7a0972304e201e2a5336a69d00e112c27823f554"
  end

  go_resource "github.com/docker/engine-api" do
    url "https://github.com/docker/engine-api.git",
        revision: "4290f40c056686fcaa5c9caf02eac1dde9315adf"
  end

  go_resource "github.com/docker/go-connections" do
    url "https://github.com/docker/go-connections.git",
        revision: "eb315e36415380e7c2fdee175262560ff42359da"
  end

  go_resource "github.com/docker/go-units" do
    url "https://github.com/docker/go-units.git",
        revision: "e30f1e79f3cd72542f2026ceec18d3bd67ab859c"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        revision: "f2499483f923065a842d38eb4c7f1927e6fc6e6d"
  end

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/abiosoft").mkpath
    ln_s buildpath, buildpath/"src/github.com/abiosoft/dockward"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "install", "github.com/abiosoft/dockward"
  end

  test do
    output = shell_output(bin/"dockward -v")
    assert_match "dockward version #{version}", output
  end
end
