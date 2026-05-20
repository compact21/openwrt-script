## Simple scripts for Openwrt

Some scripts tested on Openwrt 25.12.x

To avoid creating a persistent HSTS file when using wget, you can add the following alias to /etc/shinit (or your shell initialization file): [ -x /usr/bin/wget ] && alias wget="wget --hsts-file=/dev/null"

To append it automatically and ensure the change persists across upgrades, you can run:
```sh
echo '[ -x /usr/bin/wget ] && alias wget="wget --hsts-file=/dev/null"' >> /etc/shinit
echo "/etc/shinit" >> /etc/sysupgrade.conf
```
> **Note:** The alias ensures `wget` does not create a persistent `.wget-hsts` file in the overlay filesystem.

## Example: Download and run scripts on OpenWrt

You can download scripts to `/tmp` (RAM), make them executable, and run them without leaving files on the persistent filesystem:

```sh
# Create a temporary bin directory in RAM
mkdir -p /tmp/bin
export PATH=/tmp/bin:$PATH
cd /tmp

# Download scripts without creating persistent HSTS files
wget --no-hsts -qO /tmp/bin/cell_status https://raw.githubusercontent.com/compact21/openwrt-script/refs/heads/main/cell_status

# Make them executable
chmod +x /tmp/bin/cell_status

# Run the scripts
cell_status
```

> **Note:** Everything in /tmp is stored in RAM and will disappear after a reboot.
Optionally, if you want to keep the scripts across reboots, you can copy them to a persistent location like /root/bin:

Add /root/bin to your PATH

If you want scripts into /root/bin to be available globally, add it to the PATH:

```sh
mkdir -p /root/bin
sed -i 's|^export PATH=".*"|export PATH="/usr/sbin:/usr/bin:/sbin:/bin:/root/bin"|' /etc/profile
echo "/etc/profile" >> /etc/sysupgrade.conf
echo "/root/" >> /etc/sysupgrade.conf
mv /tmp/bin/cell_status /root/bin/
```
