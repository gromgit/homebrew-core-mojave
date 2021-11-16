class Gabedit < Formula
  desc "GUI to computational chemistry packages like Gamess-US, Gaussian, etc."
  homepage "https://gabedit.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gabedit/gabedit/Gabedit250/GabeditSrc250.tar.gz"
  version "2.5.0"
  sha256 "45cdde213a09294bbf2df5f324ea11fc4c4045b3f9d58e4d67979e6f071c7689"
  revision 2

  # Consider switching back to checking SourceForge releases once we can alter
  # the matched version from `250` to `2.5.0`.
  livecheck do
    url "https://sites.google.com/site/allouchear/Home/gabedit/download"
    regex(/current stable version of gabedit is v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "0ee75766dad966a60b38b8a7f5abf71a134e808192c60bc41d55f847cafd4579"
    sha256 cellar: :any, big_sur:       "ec85ca37b2fce63ac9064364a740fef98389adb8729a6cdb1d2b969c8faff151"
    sha256 cellar: :any, catalina:      "af6b9870f2b34921313f3f38329a507e450462bf74055880f8c572e153c78932"
    sha256 cellar: :any, mojave:        "c8bd86798356203a2e554310149b51299c2221827a030fd74763c9237996fc9f"
    sha256 cellar: :any, high_sierra:   "83b205bd7a01eb782a9346f048c3c2e217ba4dc425f620853a4da066563e6b5c"
    sha256 cellar: :any, sierra:        "72d3d9bda815ffda49197241c46139686fbc0a4b2c9aeab2dce258573e5ea17b"
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "gtkglext"

  def install
    opengl_headers = MacOS.sdk_path/"System/Library/Frameworks/OpenGL.framework/Headers"
    (buildpath/"brew_include").install_symlink opengl_headers => "GL"

    inreplace "CONFIG" do |s|
      s.gsub! "-lX11", ""
      s.gsub! "-lpangox-1.0", ""
      s.gsub! "GTKCFLAGS =", "GTKCFLAGS = -I#{buildpath}/brew_include"
    end

    args = []
    args << "OMPLIB=" << "OMPCFLAGS=" if ENV.compiler == :clang
    system "make", *args
    bin.install "gabedit"
  end

  test do
    assert_predicate bin/"gabedit", :exist?
  end
end
