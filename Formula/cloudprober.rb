class Cloudprober < Formula
  desc "Active monitoring software to detect failures before your customers do"
  homepage "https://cloudprober.org"
  url "https://github.com/cloudprober/cloudprober/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "1ba5a700d7785e8ac399daca4fa7367797e48071909d72a0e9f12c06b9e62140"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cloudprober"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "a3cd5574eb57b1135f765678f5240d7638393ae21d93bcfccff7ca46f2103a14"
  end

  depends_on "go" => :build

  def install
    system "make", "cloudprober", "VERSION=v#{version}"
    bin.install "cloudprober"
  end

  test do
    io = IO.popen("#{bin}/cloudprober --logtostderr", err: [:child, :out])
    io.any? do |line|
      /Initialized status surfacer/.match?(line)
    end
  end
end
