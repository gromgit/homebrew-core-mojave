class Kubeless < Formula
  desc "Kubernetes Native Serverless Framework"
  homepage "https://kubeless.io"
  url "https://github.com/vmware-archive/kubeless/archive/v1.0.8.tar.gz"
  sha256 "c25dd4908747ac9e2b1f815dfca3e1f5d582378ea5a05c959f96221cafd3e4cf"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kubeless"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "be3ec3c3ad4ada79d6409def37daee29fc49434bc22c7e579dd4e18e695d6916"
  end

  deprecate! date: "2022-03-18", because: :repo_archived

  depends_on "go@1.17" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w -X github.com/vmware-archive/kubeless/pkg/version.Version=v#{version}
    ]
    system "go", "build", "-ldflags", ldflags.join(" "), "-trimpath",
           "-o", bin/"kubeless", "./cmd/kubeless"
    prefix.install_metafiles

    generate_completions_from_executable(bin/"kubeless", "completion")
  end

  test do
    port = free_port
    server = TCPServer.new("127.0.0.1", port)

    pid = fork do
      loop do
        socket = server.accept
        request = socket.gets
        request_path = request.split[1]
        runtime_images_data = <<-'EOS'.gsub(/\s+/, "")
        [{
          \"ID\": \"python\",
          \"versions\": [{
            \"name\": \"python27\",
            \"version\": \"2.7\",
            \"httpImage\": \"kubeless/python\"
          }]
        }]
        EOS
        response = case request_path
        when "/api/v1/namespaces/kubeless/configmaps/kubeless-config"
          <<-EOS
          {
            "kind": "ConfigMap",
            "apiVersion": "v1",
            "metadata": { "name": "kubeless-config", "namespace": "kubeless" },
            "data": {
              "runtime-images": "#{runtime_images_data}"
            }
          }
          EOS
        when "/apis/kubeless.io/v1beta1/namespaces/default/functions"
          <<-EOS
          {
            "apiVersion": "kubeless.io/v1beta1",
            "kind": "Function",
            "metadata": { "name": "get-python", "namespace": "default" }
          }
          EOS
        when "/apis/apiextensions.k8s.io/v1beta1/customresourcedefinitions/functions.kubeless.io"
          <<-EOS
          {
            "apiVersion": "apiextensions.k8s.io/v1beta1",
            "kind": "CustomResourceDefinition",
            "metadata": { "name": "functions.kubeless.io" }
          }
          EOS
        else
          "OK"
        end
        socket.print "HTTP/1.1 200 OK\r\n" \
                     "Content-Length: #{response.bytesize}\r\n" \
                     "Connection: close\r\n"
        socket.print "\r\n"
        socket.print response
        socket.close
      end
    end

    (testpath/"kube-config").write <<~EOS
      apiVersion: v1
      clusters:
      - cluster:
          certificate-authority-data: test
          server: http://127.0.0.1:#{port}
        name: test
      contexts:
      - context:
          cluster: test
          user: test
        name: test
      current-context: test
      kind: Config
      preferences: {}
      users:
      - name: test
        user:
          token: test
    EOS

    (testpath/"test.py").write "function_code"

    begin
      ENV["KUBECONFIG"] = testpath/"kube-config"
      system bin/"kubeless", "function", "deploy", "--from-file", "test.py",
                             "--runtime", "python2.7", "--handler", "test.foo",
                             "test"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
