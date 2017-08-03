HC=ghc
HC_FLAG=--make

TARGET=main

all: $(TARGET).hs
	$(HC) $(HC_FLAG) $(TARGET).hs

clean:
	rm -f *.o
	rm -f *.hi
	rm -f *.hs
	rm -f $(TARGET)
