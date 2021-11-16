class WaitOn < Formula
  desc "Provides shell scripts with access to kqueue(3)"
  homepage "https://www.freshports.org/sysutils/wait_on/"
  url "https://pkg.freebsd.org/ports-distfiles/wait_on-1.1.tar.gz"
  mirror "https://mirrorservice.org/sites/distfiles.macports.org/wait_on/wait_on-1.1.tar.gz"
  sha256 "d7f40655f5c11e882890340826d1163050e2748de66b292c15b10d32feb6490f"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ca26e2aeef0c80f7b61b392ea50b03f7465bcdc0c8c3be2248aca538935fdc78"
    sha256 cellar: :any_skip_relocation, big_sur:       "b7a8f90a892e9b2cbe4455d9fd4aedfdf7b65c3534e00b8849e94652171bd4e3"
    sha256 cellar: :any_skip_relocation, catalina:      "befef0facd28d26c22ed14197e74c1bff41c9cd2f787ae4bee59027cfb89b2c7"
    sha256 cellar: :any_skip_relocation, mojave:        "500c8192d5cc65f906844fcca12f837d1e498d396ac60f368c195cf773bb6d4d"
    sha256 cellar: :any_skip_relocation, high_sierra:   "ca2dfaf2a1449ae1066826846cbdc9963efb837277f258c57304669f8615ad0f"
    sha256 cellar: :any_skip_relocation, sierra:        "31a21b915c4f8d901ed5d51d14f3f2f81993ed07891832fdbfb314b7cc8599e5"
    sha256 cellar: :any_skip_relocation, el_capitan:    "f362694f30021c32557e23b5add36ac4bdfbcabc6056996c5d23fc125527d85d"
    sha256 cellar: :any_skip_relocation, yosemite:      "1719c6f8843af24cc8a985ee3e246fd10c6fe7b08297a1086e0636ed437199fd"
  end

  depends_on "bsdmake" => :build

  def install
    system "bsdmake"
    bin.install "wait_on"
    man1.install "wait_on.1.gz"
  end

  test do
    system "#{bin}/wait_on", "-v"
  end
end
