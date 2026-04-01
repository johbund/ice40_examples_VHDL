import serial

PORT = '/dev/ttyUSB1'
BAUD = 9600

ser = serial.Serial(PORT, BAUD, timeout=2)

in1 = input("Enter first number: ")
ser.write(int(in1).to_bytes())

in2 = input("Enter second number: ")
ser.write(int(in2).to_bytes())

result = ser.readline()
print("Result: ", int.from_bytes(result))

