if os[:family] == 'redhat' && os[:release].start_with?('6')
  describe command('/etc/init.d/iptables status') do
    its(:stdout) { should match /ACCEPT.*tcp dpt:22/ }
  end

  describe command('/etc/init.d/ip6tables status') do
    its(:stdout) { should match /ACCEPT.*tcp dpt:22/ }
  end

else
  describe iptables do
    it { should have_rule('-A FWR -p tcp -m tcp --dport 22 -j ACCEPT') }
  end

  describe file('/etc/ip6tables.d/sshd') do
    it { should exist }
  end

  describe file('/etc/ip6tables.d/dhcpv6') do
    it { should exist }
  end

  describe command('/sbin/ip6tables-save') do
    its(:stdout) { should match %r{-A INPUT -d fe80::/10 -p udp -m udp --dport 546 -m state --state NEW -j ACCEPT} }
  end
end
