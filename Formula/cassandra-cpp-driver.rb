class CassandraCppDriver < Formula
  desc "DataStax C/C++ Driver for Apache Cassandra"
  homepage "https://docs.datastax.com/en/developer/cpp-driver/latest"
  url "https://github.com/datastax/cpp-driver/archive/2.16.2.tar.gz"
  sha256 "de60751bd575b5364c2c5a17a24a40f3058264ea2ee6fef19de126ae550febc9"
  license "Apache-2.0"
  head "https://github.com/datastax/cpp-driver.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cassandra-cpp-driver"
    rebuild 1
    sha256 cellar: :any, mojave: "61e085b276bf2ffed476f59aa5ac02712a38c84c8e7f77fde7f05f7cc06363c9"
  end

  depends_on "cmake" => :build
  depends_on "libuv"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DLIBUV_ROOT_DIR=#{Formula["libuv"].opt_prefix}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <cassandra.h>

      int main(int argc, char* argv[]) {
        CassCluster* cluster = cass_cluster_new();
        CassSession* session = cass_session_new();

        CassFuture* future = cass_session_connect(session, cluster);

        // Because we haven't set any contact points, this connection
        // should fail even if a server is running locally
        CassError error = cass_future_error_code(future);
        if (error != CASS_OK) {
          printf("connection failed");
        }

        cass_future_free(future);

        cass_session_free(session);
        cass_cluster_free(cluster);

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lcassandra", "-o", "test"
    assert_equal "connection failed", shell_output("./test")
  end
end
