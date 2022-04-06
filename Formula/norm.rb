class Norm < Formula
  desc "NACK-Oriented Reliable Multicast"
  homepage "https://www.nrl.navy.mil/itd/ncs/products/norm"
  url "https://github.com/USNavalResearchLaboratory/norm/releases/download/v1.5.9/src-norm-1.5.9.tgz"
  sha256 "ef6d7bbb7b278584e057acefe3bc764d30122e83fa41d41d8211e39f25b6e3fa"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/norm"
    sha256 cellar: :any, mojave: "5d94d95876aeece0d30ef7338de954efd53af9e5b0b1793a89b747a8ddb5af31"
  end

  depends_on "python@3.10" => :build

  # Fix warning: 'visibility' attribute ignored [-Wignored-attributes]
  # Remove in the next release
  #
  # Ref https://github.com/USNavalResearchLaboratory/norm/pull/27
  patch do
    url "https://github.com/USNavalResearchLaboratory/norm/commit/476b8bb7eba5a9ad02e094de4dce05a06584f5a0.patch?full_index=1"
    sha256 "08f7cc7002dc1afe6834ec60d4fea5c591f88902d1e76c8c32854a732072ea56"
  end

  def install
    system "python3", "./waf", "configure", "--prefix=#{prefix}"
    system "python3", "./waf", "install"

    include.install "include/normApi.h"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <normApi.h>

      int main()
      {
        NormInstanceHandle i;
        i = NormCreateInstance(false);
        assert(i != NORM_INSTANCE_INVALID);
        NormDestroyInstance(i);
        return 0;
      }
    EOS
    system ENV.cxx, "test.c", "-L#{lib}", "-lnorm", "-o", "test"
    system "./test"
  end
end
