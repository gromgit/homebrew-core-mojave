class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-3.4.1.tar.xz"
  sha256 "7e088109ad5dfbcb08a9a6b1dd70ea8236093fed8a13ee9d9c98881d7b1aeae7"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/weechat"
    sha256 mojave: "c3af62ebcdfcbc6e31313dc736704dedbc44bcb551d34f9f2d9bccd0c5cbb6b2"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "aspell"
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "perl"
  depends_on "python@3.10"
  depends_on "ruby@3.0"

  uses_from_macos "curl"
  uses_from_macos "tcl-tk"

  on_macos do
    depends_on "libiconv"
  end

  def install
    args = std_cmake_args + %W[
      -DENABLE_MAN=ON
      -DENABLE_GUILE=OFF
      -DCA_FILE=#{Formula["gnutls"].pkgetc}/cert.pem
      -DENABLE_JAVASCRIPT=OFF
      -DENABLE_PHP=OFF
    ]

    # Fix error: '__declspec' attributes are not enabled
    # See https://github.com/weechat/weechat/issues/1605
    args << "-DCMAKE_C_FLAGS=-fdeclspec" if ENV.compiler == :clang

    # Fix system gem on Mojave
    ENV["SDKROOT"] = ENV["HOMEBREW_SDKROOT"]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install", "VERBOSE=1"
    end
  end

  test do
    system "#{bin}/weechat", "-r", "/quit"
  end
end
