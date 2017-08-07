HC=ghc
HC_FLAG=--make

TARGET=main

all: $(TARGET).hs
	$(HC) $(HC_FLAG) $(TARGET).hs

clean:
	rm -f *.dec
	rm -f *.o
	rm -f *.hi
	rm -f $(TARGET)
