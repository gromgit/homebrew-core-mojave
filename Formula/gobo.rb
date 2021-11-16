class Gobo < Formula
  desc "Free and portable Eiffel tools and libraries"
  homepage "http://www.gobosoft.com/"
  url "https://downloads.sourceforge.net/project/gobo-eiffel/gobo-eiffel/20.05/gobo2005-src.tar.gz"
  sha256 "047b6710abd94d1c1366316b4411d5cc1a3752bb60155c24e2a6d81494d63e5b"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:     "1f302b672e67e600556c1d5e30751bb0ca1a47f19f8167bf7661b1fd9dc9e7d4"
    sha256 cellar: :any_skip_relocation, catalina:    "a7cd43939f9300895b1b9261ae14dfab076c9daca40f553d1b6b7b263e6b5b98"
    sha256 cellar: :any_skip_relocation, mojave:      "a4177e9921a0ccb52b426aea6bd000b3492545f763549fa979d082693041b41c"
    sha256 cellar: :any_skip_relocation, high_sierra: "72337bad76bfb21be107f01d587c6f4f968e5f4e1b94343e936e7086e59d6308"
  end

  depends_on "eiffelstudio" => :test

  def install
    ENV["GOBO"] = buildpath
    ENV.prepend_path "PATH", buildpath/"bin"
    system buildpath/"bin/install.sh", "-v", "--threads=#{ENV.make_jobs}", ENV.compiler
    (prefix/"gobo").install Dir[buildpath/"*"]
    (Pathname.glob prefix/"gobo/bin/ge*").each do |p|
      (bin/p.basename).write_env_script p,
                                        "GOBO" => prefix/"gobo",
                                        "PATH" => "#{prefix/"gobo/bin"}:$PATH"
    end
  end

  test do
    (testpath/"build.eant").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <project name="hello" default="help">
        <description>
          system: "Hello World test program"
        </description>
        <inherit>
          <parent location="${GOBO}/library/common/config/eiffel.eant">
            <redefine target="init_system" />
          </parent>
        </inherit>
        <target name="init_system" export="NONE">
          <set name="system" value="hello" />
          <set name="system_dir" value="#{testpath}" />
        </target>
      </project>
    EOS
    (testpath/"system.ecf").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <system
          xmlns="http://www.eiffel.com/developers/xml/configuration-1-20-0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://www.eiffel.com/developers/xml/configuration-1-20-0
                              http://www.eiffel.com/developers/xml/configuration-1-20-0.xsd"
          name="hello"
          library_target="all_classes">
        <description>
          system: "Hello World test program"
        </description>
        <target name="all_classes">
          <root all_classes="true" />
          <file_rule>
            <exclude>/EIFGENs$</exclude>
          </file_rule>
          <variable name="GOBO_LIBRARY" value="#{prefix/"gobo"}" />
          <library name="free_elks" location="${GOBO_LIBRARY}/library/free_elks/library_${GOBO_EIFFEL}.ecf" readonly="true" />
          <library name="kernel" location="${GOBO_LIBRARY}/library/kernel/library.ecf" readonly="true"/>
          <cluster name="hello" location="./" />
        </target>
        <target name="hello" extends="all_classes">
          <root class="HELLO" feature="execute" />
          <setting name="console_application" value="true" />
          <capability>
            <concurrency use="none" />
          </capability>
        </target>
      </system>
    EOS
    mkdir "src" do
      (testpath/"hello.e").write <<~EOS
        note
          description:
            "Hello World test program"
        class HELLO
        inherit
          KL_SHARED_STANDARD_FILES
        create
          execute
        feature
          execute do
            std.output.put_string ("Hello, world!")
          end
        end
      EOS
    end
    system bin/"geant", "-v", "compile_ge"
    assert_equal "Hello, world!", shell_output(testpath/"hello")
    system bin/"geant", "-v", "clean"
    system bin/"geant", "-v", "compile_ise"
    assert_equal "Hello, world!", shell_output(testpath/"hello")
    system bin/"geant", "-v", "clean"
  end
end
