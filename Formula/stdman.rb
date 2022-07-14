class Stdman < Formula
  desc "Formatted C++ stdlib man pages from cppreference.com"
  homepage "https://github.com/jeaye/stdman"
  url "https://github.com/jeaye/stdman/archive/2022.02.01.tar.gz"
  sha256 "84d36791514f20a814f1530e9f4e6ff67e538e0c9b3ef25db4b007f9861c4890"
  license "MIT"
  version_scheme 1
  head "https://github.com/jeaye/stdman.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "3a74e020e777587f893a2c62e7fda36ca37ba021206dbe0a57f29b9970ad6642"
  end

  on_linux do
    depends_on "man-db" => :test
  end

  # Preserve timestamps when doing `make install`.
  # This helps ensure uniform bottles across builds.
  # https://github.com/jeaye/stdman/pull/49
  patch do
    url "https://github.com/jeaye/stdman/commit/862e5132c18275661c468083baeab42dc4c335f2.patch?full_index=1"
    sha256 "8b2c785fc859e31fcb8c58884eff64c371bb9afd001979ad1158517c77ea1041"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    man = OS.mac? ? "man" : "gman"
    system man, "-w", "std::string"
  end
end
