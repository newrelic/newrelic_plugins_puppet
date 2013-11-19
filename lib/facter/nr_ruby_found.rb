Facter.add(:nr_ruby_found) do
  confine :kernel => :linux
  setcode do
    if File.exists?('/opt/puppet/bin/ruby')
      ruby = '/opt/puppet/bin/ruby'
    else
      ruby = Facter::Util::Resolution.exec('which --skip-alias ruby 2> /dev/null')
    end
    if ruby
      version = Facter::Util::Resolution.exec( ruby + " -e 'puts RUBY_VERSION'")
      version.start_with?('1.8.7', '1.9', '2.0')
    else
      false
    end
  end
end