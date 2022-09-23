class Wsk < Formula
  desc "OpenWhisk Command-Line Interface (CLI)"
  homepage "https://openwhisk.apache.org/"
  url "https://github.com/apache/openwhisk-cli/archive/1.2.0.tar.gz"
  sha256 "cafc57b2f2e29f204c00842541691038abcc4e639dd78485f9c042c93335f286"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/wsk"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "9f69a72d9446cf7fc3add4d0ea897b978adc8c148fbf082cf20e0a9457104c7b"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    system "go-bindata", "-pkg", "wski18n", "-o",
                          "wski18n/i18n_resources.go", "wski18n/resources"

    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"wsk", "sdk", "install", "bashauto", "--stdout",
                                         shells: [:bash], shell_parameter_format: :none)
  end

  test do
    system "#{bin}/wsk", "property", "set", "--apihost", "https://127.0.0.1"
  end
end
