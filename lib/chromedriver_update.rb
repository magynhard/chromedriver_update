require 'os'
require 'open-uri'
require 'zip'
require 'httparty'
require 'fileutils'
require 'json'

require_relative 'chromedriver_update/version'
require_relative 'custom_errors/chromedriver_not_found_error'
require_relative 'custom_errors/chrome_not_found_error'

class ChromedriverUpdate

  CHROME_DOWNLOADS_LIST_URL = 'https://googlechromelabs.github.io/chrome-for-testing/known-good-versions-with-downloads.json'

  #
  # Update the installed version of chromedriver automatically fitting to the currently installed version of chrome
  #
  def self.auto_update_chromedriver
    if installed_chrome_version.split(".").first != installed_chromedriver_version.split(".").first
      original_chromedriver_version = installed_chromedriver_version
      chromedriver_zip = HTTParty.get(chromedriver_link_for_version(installed_chrome_version))
      if chromedriver_zip.code == 404 # fallback to latest lower version
        chromedriver_zip = HTTParty.get(chromedriver_closest_link_for_version(installed_chrome_version))
      end
      destination_dir = File.expand_path(File.dirname(__FILE__) + "/../tmp")
      Zip::File.open_buffer(chromedriver_zip.body) do |zip_files|
        zip_files.each do |entry|
          if (entry.name.end_with?("/chromedriver") || entry.name.end_with?("/chromedriver.exe"))
            download_path = File.join(destination_dir, File.basename(entry.name))
            FileUtils.rm_f(download_path)
            entry.extract(download_path)
            FileUtils.mv(download_path, chromedriver_path, force: true)
          end
        end
      end
      puts "Updated Chromedriver from '#{original_chromedriver_version}' to '#{installed_chromedriver_version}'! Chrome is '#{installed_chrome_version}'."
    else
      puts "Chromedriver is already up to date at major version! Chromedriver: '#{installed_chromedriver_version}' Chrome: '#{installed_chrome_version}'"
    end
  end

  #
  # Get the currently installed version of chrome
  #
  # @return [String] current installed chrome version
  #
  def self.installed_chrome_version
    begin
      if OS.windows?
        version = `reg query "HKEY_CURRENT_USER\\Software\\Google\\Chrome\\BLBeacon" /v version`
        version.scan(/version[^0-9]*([0-9\.]+)/).flatten.first
      elsif OS.mac?
        version = `/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --version`
        version.scan(/([0-9\.]+)/).flatten.first
      else
        version = ""
        begin
          version = `google-chrome --version`
        rescue Errno::ENOENT => e
          version = `google-chrome-stable --version`
        end
        version.scan(/([0-9\.]+)/).flatten.first
      end
    rescue => e
      raise ChromeNotFoundError.new "Could not detect a installed chrome version!"
    end
  end

  #
  # Get the currently installed version of chromedriver
  #
  # @return [String] current installed chromedriver version
  #
  def self.installed_chromedriver_version
    `#{chromedriver_path} --version`.scan(/([0-9\.]+)/).flatten.first
  end

  def self.chromedriver_link_for_version(version)
    if OS.windows?
      "https://storage.googleapis.com/chrome-for-testing-public/#{version}/win64/chromedriver-win64.zip"
    elsif OS.mac?
      "https://storage.googleapis.com/chrome-for-testing-public/#{version}/mac-arm64/chromedriver-mac-arm64.zip"
    else
      "https://storage.googleapis.com/chrome-for-testing-public/#{version}/linux64/chromedriver-linux64.zip"
    end
  end

  #
  # Get the download URL of the closest chromedriver version fitting the given chrome version
  #
  # @param [String] version of chrome to find the best chromedriver version for
  # @return [String] link to the matching chromedriver download for the local platform
  #
  def self.chromedriver_closest_link_for_version(version)
    platform = if OS.windows?
                 "win64"
               elsif OS.mac?
                 "mac-arm64"
               else
                 "linux64"
               end
    list = JSON.parse(HTTParty.get(CHROME_DOWNLOADS_LIST_URL).body)
    latest_match = list['versions'].filter { |el| el['version'].start_with?(version.split(".")[0...1].join(".")) && el['version'].split(".")[2].to_i < version.split(".")[2].to_i && el['downloads']['chromedriver'] }.last
    latest_match['downloads']['chromedriver'].filter { |el| el['platform'] == platform }.first['url']
  end

  #
  # Get the path of the installed chromedriver
  #
  # @return [String] path to the installed chromedriver
  # @raise [ChromedriverNotFoundError] if no chromedriver could be found
  def self.chromedriver_path
    version = if OS.windows?
                `where chromedriver`.strip
              else
                `which chromedriver`.strip
              end
    if version == ""
      raise ChromedriverNotFoundError.new "Could not detect installed chromedriver!"
    else
      version
    end
  end
end
