control 'docker' do
  title 'Docker installation basic checks'
  desc 'Checks the docker service and runs a "hello world" container'

  describe systemd_service('docker') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end

  describe command('sudo docker run hello-world') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /.*This message shows that your installation appears to be working correctly\..*/ }
  end

end