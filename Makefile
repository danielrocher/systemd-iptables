IPTABLES_CONF_DIR := etc/iptables
SYSTEMD_CONF_DIR := etc/systemd/system
IPV4_CONF_FILE := iptables.service
IPV6_CONF_FILE := ip6tables.service


install: install_ip4tables install_ip6tables

uninstall: stop_and_disable_iptables uninstall_configuration_files reload_systemd

reload_systemd:
	systemctl daemon-reload

install_configuration_files:
	cp -r $(IPTABLES_CONF_DIR) /etc/
	cp -r $(SYSTEMD_CONF_DIR)/$(IPV4_CONF_FILE) /$(SYSTEMD_CONF_DIR)
	cp -r $(SYSTEMD_CONF_DIR)/$(IPV6_CONF_FILE) /$(SYSTEMD_CONF_DIR)
	chmod o-rwx /$(IPTABLES_CONF_DIR) -R


install_ip4tables: install_configuration_files reload_systemd
	systemctl enable $(IPV4_CONF_FILE)
	systemctl restart $(IPV4_CONF_FILE)
	
install_ip6tables: install_configuration_files reload_systemd
	systemctl enable $(IPV6_CONF_FILE)
	systemctl restart $(IPV6_CONF_FILE)

uninstall_configuration_files:
	rm -rf /$(IPTABLES_CONF_DIR)
	rm -f /$(SYSTEMD_CONF_DIR)/$(IPV4_CONF_FILE)
	rm -f /$(SYSTEMD_CONF_DIR)/$(IPV6_CONF_FILE)

stop_and_disable_iptables:
	systemctl stop $(IPV4_CONF_FILE)
	systemctl disable $(IPV4_CONF_FILE)
	systemctl stop $(IPV6_CONF_FILE)
	systemctl disable $(IPV6_CONF_FILE)


