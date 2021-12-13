class Osm < Formula
  desc "Open Service Mesh (OSM)"
  homepage "https://openservicemesh.io/"
  url "https://github.com/openservicemesh/osm.git",
      tag:      "v0.11.1",
      revision: "c01aefae509d59735d7908a32a359327ff3f2322"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/osm"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "ce7dfad0d33f6226367d7e897bc9dbfcb530d9ce98cf3d9c815f9ba9f7f72c5c"
  end

  depends_on "go" => :build
  depends_on "helm" => :build

  def install
    ENV["VERSION"] = "v"+version
    ENV["BUILD_DATE"] = time.strftime("%Y-%m-%d-%H:%M")
    system "make", "build-osm"
    bin.install "bin/osm"
  end

  test do
    assert_match "Error: Could not list namespaces related to osm", shell_output("#{bin}/osm namespace list 2>&1", 1)
    assert_match "Version: v#{version};", shell_output("#{bin}/osm version 2>&1")
  end
end
