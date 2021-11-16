# frozen_string_literal: true

require "cli/parser"
require "resource"
require "formula"

module Homebrew
  module_function

  def aspell_dictionaries_args
    Homebrew::CLI::Parser.new do
      usage_banner <<~EOS
        `aspell-dictionaries`

        Generates the new dictionaries for the `aspell` formula.
      EOS
    end
  end

  def aspell_dictionaries
    aspell_dictionaries_args.parse

    dictionary_url = "https://ftp.gnu.org/gnu/aspell/dict"
    dictionary_mirror = "https://ftpmirror.gnu.org/aspell/dict"
    languages = {}

    index_output, = curl_output("#{dictionary_url}/0index.html")
    index_output.split("<tr><td>").each do |line|
      next unless line.start_with?("<a ")

      _, language, _, path, = line.split('"')
      language.tr!("-", "_")
      languages[language] = path
    end

    resources = languages.map do |language, path|
      r = Resource.new(language)
      r.owner = Formula["aspell"]
      r.url "#{dictionary_url}/#{path}"
      r.mirror "#{dictionary_mirror}/#{path}"
      r
    end

    output = resources.map do |resource|
      resource.fetch(verify_download_integrity: false)

      <<-EOS
        resource "#{resource.name}" do
          url "#{resource.url}"
          mirror "#{resource.mirrors.first}"
          sha256 "#{resource.cached_download.sha256}"
        end

      EOS
    end

    puts output
  end
end
