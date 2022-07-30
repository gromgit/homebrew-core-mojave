class SpdxSbomGenerator < Formula
  desc "Support CI generation of SBOMs via golang tooling"
  homepage "https://github.com/opensbom-generator/spdx-sbom-generator"
  url "https://github.com/opensbom-generator/spdx-sbom-generator/archive/refs/tags/v0.0.15.tar.gz"
  sha256 "3811d652de0f27d3bfa7c025aa6815805ef347a35b46f9e2a5093cc6b26f7b08"
  license any_of: ["Apache-2.0", "CC-BY-4.0"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/spdx-sbom-generator"
    sha256 cellar: :any_skip_relocation, mojave: "06379e2e24cb044bd376cc937ad4a82e1b545b25fab5da447eca093ca8ae299b"
  end

  depends_on "go" => [:build, :test]

  def install
    target = if Hardware::CPU.arm?
      "build-mac-arm64"
    elsif OS.mac?
      "build-mac"
    else
      "build"
    end

    system "make", target

    prefix.install "bin"
  end

  test do
    system "go", "mod", "init", "example.com/tester"

    assert_equal "panic: runtime error: index out of range [0] with length 0",
                 shell_output("#{bin}/spdx-sbom-generator 2>&1", 2).split("\n")[4]
  end
end
