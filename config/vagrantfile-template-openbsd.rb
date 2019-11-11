Vagrant.configure('2') do |config|
  config.ssh.shell = 'sh'
  config.ssh.sudo_command = "doas -n %c"
  config.vm.synced_folder '', '/vagrant', disabled: true
  config.vm.provider :virtualbox do |v|
    v.check_guest_additions = false
    v.functional_vboxsf = false
  end
end
