#!/bin/bash
set -x

# Stop display manager
systemctl stop display-manager
killall gdm-wayland-session
    
# Unbind VTconsoles: might not be needed
echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind

# Unbind EFI Framebuffer
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

# Unload NVIDIA kernel modules
#modprobe -r nvidia_drm nvidia_modeset nvidia_uvm nvidia

# Detach GPU devices from host
# Use your GPU and HDMI Audio PCI host device
virsh nodedev-detach pci_0000_01_00_0
virsh nodedev-detach pci_0000_01_00_1

# Unload AMD kernel module
modprobe -r amdgpu

# Load vfio module
modprobe vfio-pci
