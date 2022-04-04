class Jinja2Cli < Formula
  include Language::Python::Virtualenv

  desc "CLI for the Jinja2 templating language"
  homepage "https://github.com/mattrobenolt/jinja2-cli"
  url "https://files.pythonhosted.org/packages/a4/22/c922839761b311b72ccc95c2ca2239311a3e80916458878962626f96922a/jinja2-cli-0.8.2.tar.gz"
  sha256 "a16bb1454111128e206f568c95938cdef5b5a139929378f72bb8cf6179e18e50"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jinja2-cli"
    sha256 cellar: :any_skip_relocation, mojave: "1218a393cc8fbd71ee37d2556082424696c27c01cd0428a949806544f17978e5"
  end

  depends_on "python@3.10"

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/1f/93/99a76d0fa1a8fc14442a6421abee323f8d15964979336eabd2a1834e9118/Jinja2-3.1.0.tar.gz"
    sha256 "a2f09a92f358b96b5f6ca6ecb4502669c4acb55d8733bbb2b2c9c4af5564c605"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = if OS.mac?
      shell_output("script -q /dev/null #{bin}/jinja2 --version")
    else
      shell_output("script -q /dev/null -e -c \"#{bin}/jinja2 --version\"")
    end
    assert_match version.to_s, output
    expected_result = <<~EOS
      The Beatles:
      - Ringo Starr
      - George Harrison
      - Paul McCartney
      - John Lennon
    EOS
    template_file = testpath/"my-template.tmpl"
    template_file.write <<~EOS
      {{ band.name }}:
      {% for member in band.members -%}
      - {{ member.first_name }} {{ member.last_name }}
      {% endfor -%}
    EOS
    template_variables_file = testpath/"my-template-variables.json"
    template_variables_file.write <<~EOS
      {
        "band": {
          "name": "The Beatles",
          "members": [
            {"first_name": "Ringo",  "last_name": "Starr"},
            {"first_name": "George", "last_name": "Harrison"},
            {"first_name": "Paul",   "last_name": "McCartney"},
            {"first_name": "John",   "last_name": "Lennon"}
          ]
        }
      }
    EOS
    output = shell_output("#{bin}/jinja2 #{template_file} #{template_variables_file}")
    assert_equal output, expected_result
  end
end
