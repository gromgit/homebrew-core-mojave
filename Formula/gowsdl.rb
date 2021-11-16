class Gowsdl < Formula
  desc "WSDL2Go code generation as well as its SOAP proxy"
  homepage "https://github.com/hooklift/gowsdl"
  url "https://github.com/hooklift/gowsdl.git",
      tag:      "v0.5.0",
      revision: "51f3ef6c0e8f41ed1bdccce4c04e86b6769da313"
  license "MPL-2.0"
  head "https://github.com/hooklift/gowsdl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0391c1e4a9fdbd2f14d5daff2789d490802da3b4a09a227d021dcb1a58b2f92a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e00fdcd6cf4d9f6b4d8df22fbd7622ec946b4188944e4f5fb04aed3c29878f4"
    sha256 cellar: :any_skip_relocation, monterey:       "c810ea3ef7b3a12aeb84b71b71c0c67f6853857cd6fd778c65b9bb0b9fad157e"
    sha256 cellar: :any_skip_relocation, big_sur:        "311386c63c7c7ffda0e89c0cf753b5ce53745909e492b2866f75c157c97e48a8"
    sha256 cellar: :any_skip_relocation, catalina:       "5decccb2c1f5b9c093dc045fceede062ea21bfb0273c7cfa9d7c1cde04229e4c"
    sha256 cellar: :any_skip_relocation, mojave:         "5fa5da76a1c3677059c85a6001e90b1a1d3256d7a7942133ca4824365dbc7fec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f90850655453570875a7087b0ac6a850d059a68afba01b62a5e30e6aa7cfecc"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "build/gowsdl"
  end

  test do
    system "#{bin}/gowsdl"
  end
end
