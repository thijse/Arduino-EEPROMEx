/*
 * EEPROM Read
 *
 * Reads the value of each byte of the EEPROM and prints it
 * to the computer.
 * This example code is in the public domain.
 */

#include <EEPROMex.h>

// start reading from the first byte (address 0) of the EEPROM

int addressByte;
int addressInt;
int addressLong;
int addressFloat;
int addressDouble;

void setup()
{
  Serial.begin(9600);
  EEPROM.setMemPool(100, 120, 1024);
  EEPROM.setMaxAllowedWrites(100);
  
  // Always get the adresses first
  addressByte = EEPROM.getAdress(sizeof(byte));
  addressInt = EEPROM.getAdress(sizeof(int));
  addressLong = EEPROM.getAdress(sizeof(long));
  addressFloat = EEPROM.getAdress(sizeof(float));
  addressDouble = EEPROM.getAdress(sizeof(double));  
 
  readAndWriteByte(addressByte,120); 
  readAndWriteInt(addressInt,30000); 
  readAndWriteLong(addressLong,2000000000); 
  readAndWriteFloat(addressFloat,2000000000.000);   
}

void loop()
{
}

//template< typename T> void readAndWriteByte(int adress, T value)

void readAndWriteByte(int adress, byte value) { 
    Serial.println("storing and retreiving byte");     
    EEPROM.write(adress,value);
    value = 0;      
    value = EEPROM.read(adress);
    Serial.print(adress);
    Serial.print("\t");
    Serial.print(value, DEC);
    Serial.println(); 
}

void readAndWriteInt(int adress, int value) { 
    Serial.println("storing and retreiving Int");     
    EEPROM.writeInt(adress,value);
    value = 0;      
    value = EEPROM.readInt(adress);
    Serial.print(adress);
    Serial.print("\t");
    Serial.print(value, DEC);
    Serial.println(); 
}

void readAndWriteLong(int adress, long value) { 
    Serial.println("storing and retreiving Long");     
    EEPROM.writeLong(adress,value);
    value = 0;      
    value = EEPROM.readLong(adress);
    Serial.print(adress);
    Serial.print("\t");
    Serial.print(value, DEC);
    Serial.println(); 
}

void readAndWriteFloat(int adress, float value) { 
    Serial.println("storing and retreiving Float");     
    EEPROM.writeFloat(adress,value);
    value = 0.0;      
    value = EEPROM.readFloat(adress);
    Serial.print(adress);
    Serial.print("\t");
    Serial.print(value, DEC);
    Serial.println(); 
}
