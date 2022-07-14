class Aterm < Formula
  desc "Annotated Term for tree-like ADT exchange"
  homepage "https://web.archive.org/web/20180902175600/meta-environment.org/Meta-Environment/ATerms.html"
  url "https://web.archive.org/web/20150503094402/meta-environment.org/releases/aterm-2.8.tar.gz"
  sha256 "bab69c10507a16f61b96182a06cdac2f45ecc33ff7d1b9ce4e7670ceeac504ef"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_monterey: "ebda893b9758be7b869202f7c803c2c271d5d3538a321526a7f34cdc0c7397ca"
    sha256 cellar: :any, arm64_big_sur:  "7dda6c07018ede4897b320e3366ffbb09286150d1a03223fb921bc1f52185325"
    sha256 cellar: :any, monterey:       "42fc6a2b8e20c7085b7c1a90c672852b5cea75101ea09a49ce636c298c7473c1"
    sha256 cellar: :any, big_sur:        "61e753af9203031d48ac690e61ba826dfa86ae26b9c2a3117caa0a1994de5cbc"
    sha256 cellar: :any, catalina:       "9327ff2d137e5b01bc82a936c99bd844d29b03dc1043f9f241846564b2c78a96"
    sha256 cellar: :any, mojave:         "302f12e90b83e896318e34a1931cdee75d7de43d1c8de9163f307a9d17f1668c"
    sha256 cellar: :any, high_sierra:    "f56a13be464fa577fdad7fe82779f5e6bbe820995e1849b6741ca92807c10bf0"
    sha256 cellar: :any, sierra:         "dd7b81b3bd9a31746ab461b8d79e4c32838b7e86f540769e4c17825a4b89c1c2"
    sha256 cellar: :any, el_capitan:     "5140e20287eda941f8756dfdaf377663f84f6872d1ca3f6d70e04b554591d11a"
  end

  deprecate! date: "2021-11-03", because: :unmaintained

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    ENV.deparallelize # Parallel builds don't work
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <aterm1.h>

      int main(int argc, char *argv[]) {
        ATerm bottomOfStack;
        ATinit(argc, argv, &bottomOfStack);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lATerm", "-o", "test"
    system "./test"
  end
end
