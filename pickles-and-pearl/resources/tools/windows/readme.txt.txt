This is the version compiled on my old dev laptop

when you get the code you need VS 2017 configured for C++ dev

Open the project and set to 32, not 64 bit
Include memmap.h and memmap.cpp
Change asm.cpp line 6342 to be

byte * bankmem = new byte[Bank::banksize]

Build to release mode, and here is Pasmo (Mac is a lot easier) for Windows