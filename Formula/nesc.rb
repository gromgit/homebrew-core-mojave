class Nesc < Formula
  desc "Programming language for deeply networked systems"
  homepage "https://github.com/tinyos/nesc"
  url "https://github.com/tinyos/nesc/archive/v1.4.0.tar.gz"
  sha256 "ea9a505d55e122bf413dff404bebfa869a8f0dd76a01a8efc7b4919c375ca000"
  license "GPL-2.0"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b4d4450e60720f1c811afbf0a423de2809587d0a61bfdf73b2bd9b78054070cc"
    sha256 cellar: :any_skip_relocation, big_sur:       "9f1a0aa5ac89e1c7b0f278aaab584ce98dd4ae31a94fd9bb111287e8fcba8131"
    sha256 cellar: :any_skip_relocation, catalina:      "b2ce356c9fb1177a17e2e2b82cc7e91f9126ecc68435ba0cea0ea94f65def27c"
    sha256 cellar: :any_skip_relocation, mojave:        "9b261a0f665954574e417d0f7509d2253d09ab45f43e6db48ddaa4e81120e8ba"
    sha256 cellar: :any_skip_relocation, high_sierra:   "bb30d87ef9a3896e8dc9fa346854ecad17d2ac42ebdb3d5d800a548b839afc37"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openjdk" => :build
  depends_on "emacs" if MacOS.version >= :catalina

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    # nesc is unable to build in parallel because multiple emacs instances
    # lead to locking on the same file
    ENV.deparallelize

    system "./Bootstrap"
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
