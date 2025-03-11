all:
	nasm -felf64 ./calc.asm -o ./calc.o
#	gcc -Wall -nostartfiles -nodefaultlibs -o ./app ./calc.c
	ld -N ./calc.o -o ./app
	./app

test:
	gcc -fverbose-asm -S ./calc.c -o ./calc-autogen.asm
