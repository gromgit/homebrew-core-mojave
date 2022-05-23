class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/current/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.3.0.tar.gz"
  sha256 "5b70ccc53bb5c61ed2aa2ed5f495c0fdb474e3c4cc1b5fbbd94f6a1b96776bd2"
  license "Apache-2.0"
  head "https://github.com/couchbase/libcouchbase.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libcouchbase"
    sha256 mojave: "b93fc29eed191b7fca75d3abe61adb3e9c2884ce819c9444b03711e59d5309d2"
  end

  depends_on "cmake" => :build
  depends_on "libev"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@1.1"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DLCB_NO_TESTS=1",
                            "-DLCB_BUILD_LIBEVENT=ON",
                            "-DLCB_BUILD_LIBEV=ON",
                            "-DLCB_BUILD_LIBUV=ON"
      system "make", "install"
    end
  end

  test do
    assert_match "LCB_ERR_CONNECTION_REFUSED",
      shell_output("#{bin}/cbc cat document_id -U couchbase://localhost:1 2>&1", 1).strip
  end
end
