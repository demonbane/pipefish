require 'rubygems'
require 'crypt/blowfish'
require 'base64'
require 'optparse'

module Pipefish
  Version = "0.1.0"

  extend self

  @config = {}
  @action = :encrypt

  def execute(*args)
    opts = OptionParser.new do |opts|
      opts.banner = "Usage: pipefish [options]"

      opts.on('-k', '--key KEY', 'Specify passkey to use') do |enkey|
        @config[:enkey] = enkey
      end

      opts.on('-d', '--decrypt', 'Decrypt input') do |priv|
        @action = :decrypt
      end

      opts.on('-e', '--encrypt', 'Encrypt input (default)') do |priv|
        @action = :encrypt
      end

      opts.on('-v', '--version', 'Print version') do
        puts Pipefish::Version
        exit
      end

      opts.on('-h', '--help', 'Display this screen') do
        puts opts
        exit
      end
    end

    opts.parse!(args)

    send(@action)
    exit
  end

  def blowfish
    abort "No passkey provided, exiting." unless key && !key.empty?
    Crypt::Blowfish.new(key)
  end

  def key
    @config[:enkey] || ENV['PIPEFISH_ENKEY']
  end

  def encrypt
    payload = Base64.encode64(STDIN.read)
    puts Base64.encode64(blowfish.encrypt_string(payload))
  end

  def decrypt
    payload = Base64.decode64(STDIN.read)
    puts Base64.decode64(blowfish.decrypt_string(payload))
  end
end
