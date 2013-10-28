Facter.add(:nr_java_found) do
  confine :kernel => :linux
  setcode do
    ruby = Facter::Util::Resolution.exec('which java')
    if ruby
      long_version = Facter::Util::Resolution.exec('/usr/bin/java -version 2>&1')
      version = long_version.split("\n")[0].split('"')[1]
      version.start_with?('1.6', '1.7')
    else
      false
    end
  end
end