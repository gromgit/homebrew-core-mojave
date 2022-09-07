class V8AT315 < Formula
  desc "Google's open source JavaScript engine"
  homepage "https://github.com/v8/v8/wiki"
  url "https://github.com/v8/v8/archive/3.15.11.18.tar.gz"
  sha256 "93a4945a550e5718d474113d9769a3c010ba21e3764df8f22932903cd106314d"
  license "BSD-3-Clause"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/v8@3.15"
    rebuild 1
    sha256 cellar: :any, mojave: "607f29d89ce8384c42070567af60464636725ab438b5122ab6210aa4396cd003"
  end

  keg_only :versioned_formula

  deprecate! date: "2022-05-18", because: "depends on Python 2 to build"

  resource "gyp" do
    url "https://chromium.googlesource.com/external/gyp.git",
        revision: "f7bc250ccc4d619a1cf238db87e5979f89ff36d7"
  end

  def install
    # Bully GYP into correctly linking with c++11
    ENV.cxx11
    ENV["GYP_DEFINES"] = "clang=1 mac_deployment_target=#{MacOS.version}"
    (buildpath/"build/gyp").install resource("gyp")

    # fix up libv8.dylib install_name
    # https://github.com/Homebrew/homebrew/issues/36571
    # https://code.google.com/p/v8/issues/detail?id=3871
    inreplace "tools/gyp/v8.gyp",
              "'OTHER_LDFLAGS': ['-dynamiclib', '-all_load']",
              "\\0, 'DYLIB_INSTALL_NAME_BASE': '#{opt_lib}'"

    system "make", "native",
                   "-j#{ENV.make_jobs}",
                   "library=shared",
                   "snapshot=on",
                   "console=readline"

    prefix.install "include"
    cd "out/native" do
      lib.install Dir["lib*"]
      bin.install "d8", "lineprocessor", "mksnapshot", "preparser", "process", "shell" => "v8"
    end
  end

  test do
    assert_equal "Hello World!", pipe_output("#{bin}/v8 -e 'print(\"Hello World!\")'").chomp
  end
end
