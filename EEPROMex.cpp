/*
  EEPROMEx.cpp - Extended EEPROM library
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

/******************************************************************************
 * Includes
 ******************************************************************************/
#include "EEPROMEx.h"

/******************************************************************************
 * Definitions
 ******************************************************************************/

 #define _EEPROMEX_VERSION 1 // software version of this library
 #define _EEPROMEX_DEBUG     // Enables logging of maximum of writes and out-of-memory
/******************************************************************************
 * Constructors
 ******************************************************************************/

// Boards with ATmega328, Duemilanove, Uno, Uno SMD, Lilypad - 1024 bytes (1 kilobyte)
// Boards with ATmega1280 or 2560, Arduino Mega series – 4096 bytes (4 kilobytes)
// Boards with ATmega168, Lilypad, old Nano, Diecimila  – 512 bytes
// By default we choose conservative settings
EEPROMClassEx::EEPROMClassEx()
  :  _allowedWrites(0)
{
}
 
/******************************************************************************
 * User API
 ******************************************************************************/

void EEPROMClassEx::setMemPool(int base, int memSize) {
	//Base can only be adjusted if no addresses have already been issued
	if (_nextAvailableaddress == _base) 
		_base = base;
		_nextAvailableaddress=_base;
	
	//Ceiling can only be adjusted if not below issued addresses
	if (memSize >= _nextAvailableaddress ) 
		_memSize = memSize;

	#ifdef _EEPROMEX_DEBUG    
	if (_nextAvailableaddress != _base) 
		Serial.println("Cannot change base, addresses have been issued");

	if (memSize < _nextAvailableaddress )  
		Serial.println("Cannot change ceiling, below issued addresses");
	#endif	
	
}

void EEPROMClassEx::setMaxAllowedWrites(int allowedWrites) {
#ifdef _EEPROMEX_DEBUG
	_allowedWrites = allowedWrites;
#endif			
}

int EEPROMClassEx::getAddress(int noOfBytes){
	int availableaddress   = _nextAvailableaddress;
	_nextAvailableaddress += noOfBytes;

#ifdef _EEPROMEX_DEBUG    
	if (_nextAvailableaddress > _memSize) {
		Serial.println("Attempt to write outside of EEPROM memory");
		return -availableaddress;
	} else {
		return availableaddress;
	}
#endif
	return availableaddress;		
}
 
// All of the read/write functions first make sure the EEPROM is ready to be accessed. 
// Since this may cause long delays if a  write operation is still pending, time-critical 
// applications should first poll the EEPROM e. g. using eeprom_is_ready() before 
// attempting any actual I/O.
bool EEPROMClassEx::isReady() {
	return eeprom_is_ready();
}

uint8_t EEPROMClassEx::read(int address)
{
	return readByte(address);
}

uint8_t EEPROMClassEx::readByte(int address)
{	
	if (!isReadOk(address+sizeof(uint8_t))) return 0;
	return eeprom_read_byte((unsigned char *) address);
}

uint16_t EEPROMClassEx::readInt(int address)
{
	if (!isReadOk(address+sizeof(uint16_t))) return 0;
	return eeprom_read_word((unsigned int *) address);
}

uint32_t EEPROMClassEx::readLong(int address)
{
	if (!isReadOk(address+sizeof(uint32_t))) return 0;
	return eeprom_read_dword((unsigned long *) address);
}

float EEPROMClassEx::readFloat(int address)
{
	if (!isReadOk(address+sizeof(float))) return 0;
	float _value;
	readBlock<float>(address, _value);
	return _value;
}

double EEPROMClassEx::readDouble(int address)
{
	if (!isReadOk(address+sizeof(double))) return 0;	
	double _value;
	readBlock<double>(address, _value);
	return _value;
}

bool EEPROMClassEx::write(int address, uint8_t value)
{
	return writeByte(address, value);
}

bool EEPROMClassEx::writeByte(int address, uint8_t value)
{
	if (!isWriteOk(address+sizeof(uint8_t))) return false;
	eeprom_write_byte((unsigned char *) address, value);
	return true;
}

bool EEPROMClassEx::writeInt(int address, uint16_t value)
{
	if (!isWriteOk(address+sizeof(uint16_t))) return false;
	eeprom_write_word((unsigned int *) address, value);
	return true;
}

bool EEPROMClassEx::writeLong(int address, uint32_t value)
{
	if (!isWriteOk(address+sizeof(uint32_t))) return false;
	eeprom_write_dword((unsigned long *) address, value);
	return true;
}

bool EEPROMClassEx::writeFloat(int address, float value)
{
	return (writeBlock<float>(address, value)!=0);	
}

bool EEPROMClassEx::update(int address, uint8_t value)
{
	return (updateByte(address, value));
}

bool EEPROMClassEx::updateByte(int address, uint8_t value)
{
	return (updateBlock<uint8_t>(address, value)!=0);
}

bool EEPROMClassEx::updateInt(int address, uint16_t value)
{
	return (updateBlock<uint16_t>(address, value)!=0);
}

bool EEPROMClassEx::updateLong(int address, uint32_t value)
{
	return (updateBlock<uint32_t>(address, value)!=0);
}

bool EEPROMClassEx::updateFloat(int address, float value)
{
	return (updateBlock<float>(address, value)!=0);
}

bool EEPROMClassEx::updateDouble(int address, double value)
{
	return (writeBlock<double>(address, value)!=0);
}

bool EEPROMClassEx::isWriteOk(int address)
{
#ifdef _EEPROMEX_DEBUG    
	_writeCounts++;
	if (_allowedWrites == 0 || _writeCounts > _allowedWrites ) {
		Serial.println("Exceeded maximum number of writes");
		return false;
	}
	
	if (address > _memSize) {
		Serial.println("Attempt to write outside of EEPROM memory");
		return false;
	} else {
		return true;
	}
#endif		
	return true;
}

bool EEPROMClassEx::isReadOk(int address)
{
#ifdef _EEPROMEX_DEBUG    
	if (address > _memSize) {
		Serial.println("Attempt to write outside of EEPROM memory");
		return false;
	} else {
		return true;
	}
#endif
	return true;	
}

int EEPROMClassEx::_base= 0;
int EEPROMClassEx::_memSize= 512;
int EEPROMClassEx::_nextAvailableaddress= 0;
int EEPROMClassEx::_writeCounts =0;

EEPROMClassEx EEPROM;
