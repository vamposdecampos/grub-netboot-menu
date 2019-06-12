STAGE	:= $(shell pwd)/stage
QEMU	:= kvm
QEMUARGS := -m 1024

all:
	grub-mknetdir --net-directory=$(STAGE)

cfg:	$(STAGE)/boot/grub/grub.cfg

$(STAGE)/boot/grub/grub.cfg: grub.cfg
	cat $< > $@

run-efi: cfg
	$(QEMU) $(QEMUARGS) \
		-M q35 -bios /usr/share/ovmf/OVMF.fd \
		-net nic \
		-net user,tftp=$(STAGE),bootfile=/boot/grub/x86_64-efi/core.efi

run-pc: cfg
	$(QEMU) $(QEMUARGS) \
		-net nic \
		-net user,tftp=$(STAGE),bootfile=/boot/grub/i386-pc/core.0
