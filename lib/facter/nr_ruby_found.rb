Facter.add(:nr_ruby_found) do
  confine :kernel => :linux
  setcode do
    ruby = Facter::Util::Resolution.exec('which ruby')
    if ruby
      version = Facter::Util::Resolution.exec("ruby -e 'puts RUBY_VERSION'")
      version.start_with?('1.8.7', '1.9', '2.0')
    else
      false
    end
  end
end