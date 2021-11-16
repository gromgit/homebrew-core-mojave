class Cppcms < Formula
  desc "Free High Performance Web Development Framework"
  homepage "http://cppcms.com/wikipp/en/page/main"
  url "https://downloads.sourceforge.net/project/cppcms/cppcms/1.2.1/cppcms-1.2.1.tar.bz2"
  sha256 "10fec7710409c949a229b9019ea065e25ff5687103037551b6f05716bf6cac52"

  livecheck do
    url :stable
    regex(%r{url=.*?/cppcms[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_monterey: "c6a5fe13878c0c37e6b326f957fc7d6dda3a0987c2fb09f5c8c54f169a76012b"
    sha256 cellar: :any, arm64_big_sur:  "a76448718798b05d84c1b9a54afa83c35afc924ed5bb5a8ad592d39cff90eaee"
    sha256 cellar: :any, monterey:       "34eccbf3637e2d5193070b75247f7d6e601b83166d8023aa87077dbb4e871e0c"
    sha256 cellar: :any, big_sur:        "ebe54531c492cd6771e3eab7cfee4d4a858c5b13a91e061c9d5bb2cb75f310dc"
    sha256 cellar: :any, catalina:       "14a71b7ff0bbcbd0def75bd0a5e4552d5bfeccd24b7de17d38dcb676c37a71cf"
    sha256 cellar: :any, mojave:         "aa587cdc614e7450100ee7c9aef5259893db98db66b9aa3fce8bc928fe080de7"
    sha256 cellar: :any, high_sierra:    "3339592fd6caed70941abe444cf34c1621dd65878eea1acbd07e798d4bb5c9b4"
    sha256 cellar: :any, sierra:         "9f21d55044af09d3eced9664c2d570657f0b3221c9f3051a5311f6f197bd2a28"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"
  depends_on "pcre"

  def install
    ENV.cxx11
    system "cmake", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"hello.cpp").write <<~EOS
      #include <cppcms/application.h>
      #include <cppcms/applications_pool.h>
      #include <cppcms/service.h>
      #include <cppcms/http_response.h>
      #include <iostream>
      #include <string>

      class hello : public cppcms::application {
          public:
              hello(cppcms::service& srv): cppcms::application(srv) {}
              virtual void main(std::string url);
      };

      void hello::main(std::string /*url*/)
      {
          response().out() <<
              "<html>\\n"
              "<body>\\n"
              "  <h1>Hello World</h1>\\n"
              "</body>\\n"
              "</html>\\n";
      }

      int main(int argc,char ** argv)
      {
          try {
              cppcms::service srv(argc,argv);
              srv.applications_pool().mount(
                cppcms::applications_factory<hello>()
              );
              srv.run();
              return 0;
          }
          catch(std::exception const &e) {
              std::cerr << e.what() << std::endl;
              return -1;
          }
      }
    EOS

    port = free_port
    (testpath/"config.json").write <<~EOS
      {
          "service" : {
              "api" : "http",
              "port" : #{port},
              "worker_threads": 1
          },
          "daemon" : {
              "enable" : false
          },
          "http" : {
              "script_names" : [ "/hello" ]
          }
      }
    EOS
    system ENV.cxx, "-o", "hello", "-std=c++11", "-stdlib=libc++", "-lc++",
                    "-L#{lib}", "-lcppcms", "hello.cpp"
    pid = fork { exec "./hello", "-c", "config.json" }

    sleep 1 # grace time for server start
    begin
      assert_match(/Hello World/, shell_output("curl http://127.0.0.1:#{port}/hello"))
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
