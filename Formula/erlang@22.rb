class ErlangAT22 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-22.3.4.26/otp_src_22.3.4.26.tar.gz"
  sha256 "ee281e4638c8d671dd99459a11381345ee9d70f1f8338f5db31fc082349a370e"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/erlang@22"
    rebuild 2
    sha256 cellar: :any, mojave: "ec2a031778bd08fa45025c15c79a8897a72bac44a6606671c3f2069be6ad70ab"
  end

  keg_only :versioned_formula

  # EOL with OTP-25 release
  deprecate! date: "2022-09-20", because: :unsupported

  depends_on "openssl@1.1"
  depends_on "wxwidgets" # for GUI apps like observer

  resource "man" do
    url "https://github.com/erlang/otp/releases/download/OTP-22.3.4.25/otp_doc_man_22.3.4.25.tar.gz"
    sha256 "b715aada5a3abf0699d1c05ed55bd57f2110fb8fc58a9a67b6519d8ff8195fa8"
  end

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-22.3.4.25/otp_doc_html_22.3.4.25.tar.gz"
    sha256 "90bfd716b2189b858a62cf09503ab02eba211753e44025d39e800490642e0fa7"
  end

  def install
    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligible error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    args = %W[
      --disable-debug
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-dynamic-ssl-lib
      --enable-hipe
      --enable-shared-zlib
      --enable-smp-support
      --enable-threads
      --enable-wx
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
      --without-javac
    ]

    if OS.mac?
      args << "--enable-darwin-64bit"
      args << "--enable-kernel-poll" if MacOS.version > :el_capitan
      args << "--with-dynamic-trace=dtrace" if MacOS::CLT.installed?
    end

    system "./configure", *args
    system "make"
    system "make", "install"

    (lib/"erlang/man").install resource("man")
    doc.install resource("html")
  end

  def caveats
    <<~EOS
      Man pages can be found in:
        #{opt_lib}/erlang/man

      Access them with `erl -man`, or add this directory to MANPATH.
    EOS
  end

  test do
    system "#{bin}/erl", "-noshell", "-eval", "crypto:start().", "-s", "init", "stop"
    (testpath/"factorial").write <<~EOS
      #!#{bin}/escript
      %% -*- erlang -*-
      %%! -smp enable -sname factorial -mnesia debug verbose
      main([String]) ->
          try
              N = list_to_integer(String),
              F = fac(N),
              io:format("factorial ~w = ~w\n", [N,F])
          catch
              _:_ ->
                  usage()
          end;
      main(_) ->
          usage().

      usage() ->
          io:format("usage: factorial integer\n").

      fac(0) -> 1;
      fac(N) -> N * fac(N-1).
    EOS
    chmod 0755, "factorial"
    assert_match "usage: factorial integer", shell_output("./factorial")
    assert_match "factorial 42 = 1405006117752879898543142606244511569936384000000000", shell_output("./factorial 42")
  end
end
