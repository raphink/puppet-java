Facter.add("public_ip") do
  setcode do
    Facter::Util::Resolution.exec('/usr/bin/curl -s http://ifconfig.me/ip')
  end
end
