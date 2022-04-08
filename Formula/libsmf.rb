class Libsmf < Formula
  desc "C library for handling SMF ('*.mid') files"
  homepage "https://sourceforge.net/projects/libsmf/"
  url "https://downloads.sourceforge.net/project/libsmf/libsmf/1.3/libsmf-1.3.tar.gz"
  sha256 "d3549f15de94ac8905ad365639ac6a2689cb1b51fdfa02d77fa6640001b18099"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f71269c1ec95b265499e4a313d872ad46006be914ba0ea0251cdb772bea68407"
    sha256 cellar: :any,                 arm64_big_sur:  "44573cafe0e23d3d764b53022f5515b0c67a7d5fab0d85a01e4b25b64b0e9334"
    sha256 cellar: :any,                 monterey:       "b295f7fa144af4cdd3b8e90f4519e2abe86bec8283ed809bffdabdbec934a0e6"
    sha256 cellar: :any,                 big_sur:        "02243fbcfb6de40f0c04b2341132e19c946be2b9fdf017f1838b3043aeddcedb"
    sha256 cellar: :any,                 catalina:       "fa858ef4b6b179d578663bbdb0d5c7490ea75a3921713e577a7f848faa99b601"
    sha256 cellar: :any,                 mojave:         "bbe040e330a998499e078129097a07f2c5de9fff9c5f26a638e6f5248badda3b"
    sha256 cellar: :any,                 high_sierra:    "7a4b394b51e89bd781fcce0514b3cc58656da63fa2e317186e47828e2c271320"
    sha256 cellar: :any,                 sierra:         "45aedd028eb76b2dfbb6fa3ba9b3fc809e7265411d5d7760997a71503ebae41a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5670da1ec13772870636e0cfe96e851f021ebe997a3307725331cbea22062246"
  end

  # Linked development repo is gone: https://github.com/nilsgey/libsmf
  # Potential alt repo has no activity: https://github.com/stump/libsmf
  deprecate! date: "2022-04-02", because: :unmaintained

  # Added automake as a build dependency to update config files for ARM support.
  # Issue ref in alt repo: https://github.com/stump/libsmf/issues/10
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    # Workaround for ancient config files not recognizing aarch64 macos.
    %w[config.guess config.sub].each do |fn|
      (buildpath/fn).unlink
      cp Formula["automake"].share/"automake-#{Formula["automake"].version.major_minor}"/fn, fn
    end
    system "./configure", *std_configure_args
    system "make", "install"
  end
end
