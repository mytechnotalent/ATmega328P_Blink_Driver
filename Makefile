TARGET=program

all:
	avr-as -mmcu=atmega328p -o $(TARGET).o $(TARGET).s
	avr-ld -o $(TARGET).elf $(TARGET).o
	avr-objcopy -O ihex $(TARGET).elf $(TARGET).hex
	avrdude -c arduino -p m328p -P /dev/tty.usbserial-310 -b 57600 -U flash:w:$(TARGET).hex:i

clean:
	rm -f $(TARGET).o $(TARGET).elf $(TARGET).hex
