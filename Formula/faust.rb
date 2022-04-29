class Faust < Formula
  desc "Functional programming language for real time signal processing"
  homepage "https://faust.grame.fr"
  url "https://github.com/grame-cncm/faust/releases/download/2.40.0/faust-2.40.0.tar.gz"
  sha256 "0a8170ee8e037ee62f92d71ad8a5c3c4a9bfee5a995adfc1be9785f66727e818"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/faust"
    sha256 cellar: :any, mojave: "10085b3ad12eb7c21b9b90d66266d433eb0ad5fee4b6219c0f0b8725042b58e6"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libmicrohttpd"
  depends_on "libsndfile"
  depends_on "llvm@12"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  # Fix parallel build of Make.llvm.static
  # PR ref: https://github.com/grame-cncm/faust/pull/728
  # Remove in the next release.
  patch do
    url "https://github.com/grame-cncm/faust/commit/c0e82fd2e261bae7b4614c2cee7f2e1d913cdb4f.patch?full_index=1"
    sha256 "6beaac00630c8d6947e6e67b9e0b0ac45f573cd44aac3de4a347715127eb3ba9"
  end

  def install
    ENV.delete "TMP" # don't override Makefile variable
    system "make", "world"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"noise.dsp").write <<~EOS
      import("stdfaust.lib");
      process = no.noise;
    EOS

    system "#{bin}/faust", "noise.dsp"
  end
end
