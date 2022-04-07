class SpdxSbomGenerator < Formula
  desc "Support CI generation of SBOMs via golang tooling"
  homepage "https://github.com/opensbom-generator/spdx-sbom-generator"
  url "https://github.com/opensbom-generator/spdx-sbom-generator/archive/refs/tags/v0.0.13.tar.gz"
  sha256 "7d088f136a53d1f608b1941362c568d78cc6279df9c1bdb3516de075cb7f10c3"
  license any_of: ["Apache-2.0", "CC-BY-4.0"]
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/spdx-sbom-generator"
    sha256 cellar: :any_skip_relocation, mojave: "8f0dbb391e8ca1b88d280db3b8b37a195d1b0cd42b75a571dfd7d594424559e3"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => [:build, :test]

  def install
    target = if Hardware::CPU.arm?
      "build-mac-arm64"
    elsif OS.mac?
      "build-mac"
    else
      "build"
    end

    system "make", target

    exe = "spdx-sbom-generator"
    (libexec/"bin").install "bin/#{exe}"
    (bin/exe).write_env_script(libexec/"bin/#{exe}", PATH: "$PATH:#{Formula["go@1.17"].opt_bin}")
  end

  test do
    system Formula["go@1.17"].opt_bin/"go", "mod", "init", "example.com/tester"

    assert_equal "panic: runtime error: index out of range [0] with length 0",
                 shell_output("#{bin}/spdx-sbom-generator 2>&1", 2).split("\n")[3]
  end
end
