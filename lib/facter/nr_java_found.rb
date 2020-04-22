Facter.add(:nr_java_found) do
  confine :kernel => :linux
  setcode do
    java = Facter::Util::Resolution.exec('which java 2> /dev/null')
    if java && !java.empty?
      long_version = Facter::Util::Resolution.exec("#{java} -version 2>&1")
      version = long_version.split("\n")[0].split('"')[1]
      version > '1.5'
    else
      false
    end
  end
end
