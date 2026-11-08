# Initialize network configuration and start services
sudo systemctl start vmware-networks-configuration.service
sudo systemctl enable --now vmware-networks.service
sudo systemctl enable --now vmware-usbarbitrator.service

# Load VMware modules into your current running kernel
sudo modprobe -a vmw_vmci vmmon
