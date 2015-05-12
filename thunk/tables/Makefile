.PHONY : default clean

default :
	rm -f ff_cos.inc
	rm -f *.o cos_tablegen
	gcc cos_tablegen.c -lm -o cos_tablegen
	./cos_tablegen | sed '/^[#/]/d' > ff_cos.inc
	rm -f *.o cos_tablegen

clean :
	rm -f *.o cos_tablegen
