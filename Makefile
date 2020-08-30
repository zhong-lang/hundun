C := /usr/local/bin/clang
AS := i686-elf-as
LINK := i686-elf-ld
QEMU := qemu-system-i386
MV := mv
GRUB := grub-mkrescue

default: 编译

编译: 系统.bin
	$(MV) 系统.bin isodir/boot/os.bin
	$(GRUB) -o os.iso isodir

系统.bin: 启动.o 内核.o 链接.ld
	$(LINK) -T 链接.ld -o 系统.bin -nostdlib 启动.o 内核.o

启动.o: 启动.s
	$(AS) 启动.s -o 启动.o

内核.o: 内核.中
	$(C) --target=i386-pc-none-elf  -c -nostdlib -nodefaultlibs -mcmodel=large 内核.中 -o 内核.o

运行: 系统.bin
	$(QEMU) -kernel 系统.bin -vga vmware

清理:
	rm -f *.o
	rm -f **/*.so
	rm -f *.bin
	rm -f *.iso
