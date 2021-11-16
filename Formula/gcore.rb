class Gcore < Formula
  desc "Produce a snapshot (core dump) of a running process"
  homepage "https://web.archive.org/web/20200103164014/https://osxbook.com/book/bonus/chapter8/core/"
  url "https://dl.bintray.com/homebrew/mirror/gcore-1.3.tar.gz"
  sha256 "6b58095c80189bb5848a4178f282102024bbd7b985f9543021a3bf1c1a36aa2a"
  license "APSL-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, catalina:    "3451656da696ce7bb47816bf409dd38f279a0dde973b5d7bc60eaec62edbee9a"
    sha256 cellar: :any_skip_relocation, mojave:      "86a6941a86863482eb97fd03e40749b83b74b7a93d7c7592db4dab6acb9c859a"
    sha256 cellar: :any_skip_relocation, high_sierra: "b9e7e188bee51975ccfdb8f711101a7637f316be0e3aa6b8f80259f7b884f488"
    sha256 cellar: :any_skip_relocation, sierra:      "5fbccf36d0bd51cc4261859b7faf2cc15fe89244109b64abf83512ea73f3259f"
    sha256 cellar: :any_skip_relocation, el_capitan:  "5c48b53869e00e0456d57bfa5adde594b5c5e46f3b0678434139765f5d8167ba"
    sha256 cellar: :any_skip_relocation, yosemite:    "e215d77d74b8c878a7d7449aada4817714b13024d6bfad78b2b700271e6218ec"
  end

  keg_only :provided_by_macos

  disable! date: "2020-12-11", because: :unmaintained

  def install
    system "make"
    bin.install "gcore"
  end

  test do
    assert_match "<pid>", shell_output("#{bin}/gcore 2>&1", 22)
  end
end
