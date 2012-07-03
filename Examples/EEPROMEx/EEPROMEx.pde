/*
 * EEPROM Read
 *
 * Reads the value of each byte of the EEPROM and prints it
 * to the computer.
 * This example code is in the public domain.
 */

#include <EEPROMex.h>

// start reading from the first byte (address 0) of the EEPROM

const int maxAllowedWrites = 20;
const int memBase          = 120;
const int memCeiling       = 250;

int addressByte;
int addressInt;
int addressLong;
int addressFloat;
int addressDouble;
int addressString;


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
    Serial.println("storing and retreiving float");     
    EEPROM.writeFloat(adress,value);
    value = 0.0;      
    value = EEPROM.readFloat(adress);
    Serial.print(adress);
    Serial.print("\t");
    Serial.print(value);
    Serial.println(); 
}

void readAndWriteDouble(int adress, double value) { 
    Serial.println("storing and retreiving double");     
    EEPROM.writeDouble(adress,value);
    value = 0.0;      
    value = EEPROM.readDouble(adress);
    Serial.print(adress);
    Serial.print("\t");
    Serial.print(value);
    Serial.println(); 
}


void readAndUpdateDouble(int adress, double value) { 
    Serial.println("storing and retreiving double");     
    EEPROM.updateDouble(adress,value);
    EEPROM.updateDouble(adress,value+1);
    value = 0.0;      
    value = EEPROM.readDouble(adress);
    Serial.print(adress);
    Serial.print("\t");
    Serial.print(value);
    Serial.println(); 
}


void waitUntilReady(int adress) { 
    Serial.println("Check how much time until EEPROM ready to be accessed");     
    EEPROM.writeLong(adress,10);
    
    int loops = 0;
    while (!EEPROM.isReady()) { 
       delay(1);
       loops++;
    }
    Serial.print(loops);
    Serial.print(" ms");
    Serial.println();    
}


void errorChecking(int adress) {
    // Be sure that _EEPROMEX_DEBUG is enabled

    Serial.println("Write outside of EEPROM memory");
    EEPROM.writeLong(EEPROMSizeUno+10,1000);
    Serial.println();    
    
    Serial.println("Trying to exceed number of writes");        
    for(int i=1;i<=20; i++)
    {
        if (!EEPROM.writeLong(adress,1000)) { return; }    
    }
    Serial.println();    
}
    
   
void setup()
{
 
  Serial.begin(9600);
  EEPROM.setMemPool(memBase, memCeiling, EEPROMSizeUno);
  EEPROM.setMaxAllowedWrites(maxAllowedWrites);
  
  // Always get the adresses first
  addressByte   = EEPROM.getAdress(sizeof(byte));
  addressInt    = EEPROM.getAdress(sizeof(int));
  addressLong   = EEPROM.getAdress(sizeof(long));
  addressFloat  = EEPROM.getAdress(sizeof(float));
  addressDouble = EEPROM.getAdress(sizeof(double));  
  

  // Read and write different data primitives
  readAndWriteByte(addressByte,120); 
  readAndWriteInt(addressInt,30000); 
  readAndWriteLong(addressLong,200000000); 
  readAndWriteFloat(addressFloat,1000000.50f);     
  readAndUpdateDouble(addressDouble,1000002.50f); 

  
  // Test EEPROM access time
  //waitUntilReady(addressLong);
  
  // Test error checking
  //errorChecking(addressLong);
  
}

void loop()
{
}
    
