class Gobo < Formula
  desc "Free and portable Eiffel tools and libraries"
  homepage "http://www.gobosoft.com/"
  url "https://downloads.sourceforge.net/project/gobo-eiffel/gobo-eiffel/22.01/gobo2201-src.tar.gz"
  sha256 "ed2d82ce3c271e60914a42bde1d1c99446df8902ae1b62fd0e4dca2b99de8068"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gobo"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "a36791c6b07fbb0638b43464c4866669bf9f837e6f191fb42ffdc61ac2e7cd54"
  end

  depends_on "eiffelstudio" => :test

  def install
    ENV["GOBO"] = buildpath
    ENV.prepend_path "PATH", buildpath/"bin"
    # The value for compiler needs to be an unversioned name, but it will still use
    # the compiler shim which will choose the correct compiler.
    compiler = OS.mac? ? "clang" : "gcc"
    system buildpath/"bin/install.sh", "-v", "--threads=#{ENV.make_jobs}", compiler
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
