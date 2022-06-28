# frozen_string_literal: true

require 'open-uri'
module WebpackHelper
  class BundleNotFound < StandardError; end

  def webpack_asset_tag(entry, **options)
    path = asset_bundle_path("#{entry}.js")

    options = {
      src: path,
      defer: true
    }.merge(options)

    options.delete(:defer) if options[:async]

    javascript_include_tag '', **options
  end

  def stylesheet_bundle_tag(entry, **options)
    path = asset_bundle_path("#{entry}.css")

    options = {
      href: path
    }.merge(options)

    stylesheet_link_tag '', **options
  end

  private

  def asset_server
    if Rails.env.production?
      "https://#{request.host}/"
    else
      port = Rails.env.development? ? '3035' : '3000'
      "http://#{request.host}:#{port}/"
    end
  end

  def pro_manifest
    File.read('public/packs/manifest.json')
  end

  def dev_manifest
    OpenURI.open_uri("#{asset_server}packs/manifest.json").read
  end

  def test_manifest
    File.read('public/packs/manifest.json')
  end

  def manifest
    @manifest ||= Rails.env.development? ? JSON.parse(dev_manifest) : JSON.parse(pro_manifest)
  end

  def valid_entry?(entry)
    return true if manifest.key?(entry)

    raise BundleNotFound, "Could not find bundle with name #{entry}"
  end

  def asset_bundle_path(entry, **options)
    valid_entry?(entry)
    asset_path("#{asset_server}packs/" + manifest.fetch(entry), **options)
  end
end
