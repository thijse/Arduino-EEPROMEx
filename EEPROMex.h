/*
  EEPROMEx.h - Extended EEPROM library
  Copyright (c) 2012 Thijs Elenbaas.  All right reserved.

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/

#ifndef EEPROMEX_h
#define EEPROMEX_h

#if ARDUINO >= 100
#include <Arduino.h> 
#else
#include <WProgram.h> 
#endif
#include <inttypes.h>
#include <avr/eeprom.h>

// Boards with ATmega328, Duemilanove, Uno, UnoSMD, Lilypad - 1024 bytes (1 kilobyte)
// Boards with ATmega1280 or 2560, Arduino Mega series – 4096 bytes (4 kilobytes)
// Boards with ATmega168, Lilypad, old Nano, Diecimila  – 512 bytes (1/2 kilobyte)

#define EEPROMSizeATmega168   512     
#define EEPROMSizeATmega328   1024     
#define EEPROMSizeATmega1280  4096     

#define EEPROMSizeUno         EEPROMSizeATmega328     
#define EEPROMSizeUnoSMD      EEPROMSizeATmega328
#define EEPROMSizeLilypad     EEPROMSizeATmega328
#define EEPROMSizeDuemilanove EEPROMSizeATmega328
#define EEPROMSizeMega        EEPROMSizeATmega1280
#define EEPROMSizeDiecimila   EEPROMSizeATmega168
#define EEPROMSizeNano        EEPROMSizeATmega168

class EEPROMClassEx
{
	  
  public:
	EEPROMClassEx();
	bool 	 isReady();
    void 	 setMemPool(int low, int high, int memSize);
	void 	 setMemPool(int low);
	void  	 setMaxAllowedWrites(int allowedWrites);
	int 	 getAdress(int noOfBytes);
    uint8_t  read(int);
	uint8_t  readByte(int);
    uint16_t readInt(int);
    uint32_t readLong(int);
	float    readFloat(int);
	double   readDouble(int);
	
	// expose explicit AVR functions
    bool     write(int, uint8_t);
	bool     writeByte(int, uint8_t);
	bool 	 writeInt(int, uint16_t);
	bool 	 writeLong(int, uint32_t);
	bool 	 writeFloat(int, float);
	bool 	 writeDouble(int, double);

    // Use template for other data formats
	template <class T> int readBlock(int address, T& value)
	{		
		eeprom_read_block((void*)&value, (const void*)address, sizeof(value));
		return sizeof(value);
	}
	
	template <class T> int writeBlock(int address, const T& value)
	{
		if (!isWriteOk(address+sizeof(value))) return 0;
		eeprom_write_block((void*)&value, (void*)address, sizeof(value));			  			  
		return sizeof(value);
	}
		
	template <class T> int updateBlock(int address, const T& value)
	{
		if (!isWriteOk(address+sizeof(value))) return 0;
		const byte* bytePointer = (const byte*)(const void*)&value;
		unsigned int i;
		for (i = 0; i < sizeof(value); i++) {
			if (read(address)!=*bytePointer) {
				write(address, *bytePointer);
				Serial.print("update");
			}
			address++;
			*bytePointer++;
		}
		return i;
	}
	
	bool     update(int, uint8_t);
	bool     updateByte(int, uint8_t);
	bool 	 updateInt(int, uint16_t);
	bool 	 updateLong(int, uint32_t);
	bool 	 updateFloat(int, float);
	bool 	 updateDouble(int, double);
	
	
private:
	static int _base;
	static int _ceiling;
	static int _memSize;
	static int _nextAvailableAdress;	
	static int _writeCounts;
	int _allowedWrites;	
	bool checkWrite(int base,int noOfBytes);	
	bool isWriteOk(int address);
	bool isReadOk(int address);
};

extern EEPROMClassEx EEPROM;

#endif

