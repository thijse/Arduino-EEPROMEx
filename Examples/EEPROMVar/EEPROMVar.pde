/*
 * EEPROM Read
 *
 * Reads the value of each byte of the EEPROM and prints it
 * to the computer.
 * This example code is in the public domain.
 */

#include <EEPROMex.h>
#include <EEPROMvar.h>

// start reading from the first byte (address 120) of the EEPROM

const int maxAllowedWrites = 20;
const int memBase          = 120;
const int memCeiling       = 250;


void readAndWriteVar(EEPROMVar<float> &var) { 
    Serial.println("storing and retreiving EEPROMVar");     
    var = 10.5;
    var++;
    var+=8.5;
    var/=2;
    
    var.save(); 
    
    var = 0.0;      
    var.restore();
    Serial.print(var);
    Serial.println(); 
}

    
    
void setup()
{
 
  Serial.begin(9600);
  EEPROM.setMemPool(memBase, memCeiling, EEPROMSizeUno);
  EEPROM.setMaxAllowedWrites(maxAllowedWrites);
  
  EEPROMVar<float> eepromFloat(5.5);

  
  readAndWriteVar(eepromFloat);
}

void loop()
{
}
    
