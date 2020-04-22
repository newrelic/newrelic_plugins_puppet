Facter.add(:nr_ruby_found) do
  confine :kernel => :linux
  setcode do
    ruby = Facter::Util::Resolution.exec('which ruby 2> /dev/null')
    if ruby && !ruby.empty?
      version = Facter::Util::Resolution.exec("#{ruby} -e 'puts RUBY_VERSION'")
      version > '1.8.6'
    else
      false
    end
  end
end
