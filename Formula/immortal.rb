class Immortal < Formula
  desc "OS agnostic (*nix) cross-platform supervisor"
  homepage "https://immortal.run/"
  url "https://github.com/immortal/immortal/archive/0.24.4.tar.gz"
  sha256 "a343581dbe58fb0faa1c65b233a067820d8d5ecefc9726da5ad3ef979a2a0b08"
  license "BSD-3-Clause"
  head "https://github.com/immortal/immortal.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/immortal"
    sha256 cellar: :any_skip_relocation, mojave: "510928c17608462fe838d081030bac4d1c0c4df8526970e0459c45cc6ca41e49"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", "-ldflags", ldflags, "-o", "#{bin}/immortal", "cmd/immortal/main.go"
    system "go", "build", "-ldflags", ldflags, "-o", "#{bin}/immortalctl", "cmd/immortalctl/main.go"
    system "go", "build", "-ldflags", ldflags, "-o", "#{bin}/immortaldir", "cmd/immortaldir/main.go"
    man8.install Dir["man/*.8"]
    prefix.install_metafiles
  end

  test do
    system bin/"immortal", "-v"
    system bin/"immortalctl", "-v"
    system bin/"immortaldir", "-v"
  end
end
