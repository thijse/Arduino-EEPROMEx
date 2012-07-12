/*
 * EEPROMEx 
 *
 * Demonstrates reading, writing and updating data in the EEPROM
 * to the computer.
 * This example code is in the public domain.
 */

#include <EEPROMex.h>

const int maxAllowedWrites = 40;
const int memBase          = 250;

int addressByte;
int addressInt;
int addressLong;
int addressFloat;
int addressDouble;
int addressByteArray;
int addressCharArray;


void issuedAdresses() {
    Serial.println("-----------------------------------");     
    Serial.println("Following adresses have been issued");     
    Serial.println("-----------------------------------");      
    
    Serial.println("adress \t\t size");
    Serial.print(addressByte);      Serial.print(" \t\t "); Serial.println(sizeof(byte)); 
    Serial.print(addressInt);       Serial.print(" \t\t "); Serial.println(sizeof(int)); 
    Serial.print(addressLong);      Serial.print(" \t\t "); Serial.println(sizeof(long)); 
    Serial.print(addressFloat);     Serial.print(" \t\t "); Serial.println(sizeof(float)); 
    Serial.print(addressDouble);    Serial.print(" \t\t "); Serial.println(sizeof(double));     
    Serial.print(addressByteArray); Serial.print(" \t\t "); Serial.println(sizeof(sizeof(byte))*7);     
    Serial.print(addressCharArray); Serial.print(" \t\t "); Serial.println(sizeof(sizeof(char))*7);     
}

// Test reading and writing byte to EEPROM
void readAndWriteByte() { 
    Serial.println("---------------------------");     
    Serial.println("storing and retreiving byte");     
    Serial.println("---------------------------");    
    
    byte input  = 120;
    byte output = 0;
    EEPROM.write(addressByte,input);   // same function as writeByte
    output = EEPROM.read(addressByte); // same function as readByte
    
    Serial.print("adress: ");
    Serial.println(addressByte);
    Serial.print("input: ");
    Serial.println(input);
    Serial.print("output: ");
    Serial.println(output);
    Serial.println("");
    
}

// Test reading and writing int to EEPROM
void readAndWriteInt() {  
    Serial.println("--------------------------");     
    Serial.println("writing and retreiving int");     
    Serial.println("--------------------------");    
            
    int input  = 30000;
    int output = 0;
    EEPROM.writeInt(addressInt,input);
    output = EEPROM.readInt(addressInt);
    
    Serial.print("adress: ");
    Serial.println(addressInt);
    Serial.print("input: ");
    Serial.println(input);
    Serial.print("output: ");
    Serial.println(output);
    Serial.println("");    
}

// Test reading and writing long to EEPROM
void readAndWriteLong() {    
    Serial.println("----------------------------");     
    Serial.println("writing and retreiving Long");     
    Serial.println("----------------------------");    
            
    long input  = 200000000;
    long output = 0;
    EEPROM.writeLong(addressLong,input);
    output = EEPROM.readLong(addressLong);
    
    Serial.print("adress: ");
    Serial.println(addressLong);
    Serial.print("input: ");
    Serial.println(input);
    Serial.print("output: ");
    Serial.println(output);
    Serial.println("");    
}

// Test reading and writing float to EEPROM
void readAndWriteFloat() { 
    Serial.println("----------------------------");     
    Serial.println("writing and retreiving float");     
    Serial.println("----------------------------");    
            
    double input  = 1010102.50;
    double output = 0.0;
    EEPROM.writeFloat(addressFloat,input);
    output = EEPROM.readFloat(addressFloat);
    
    Serial.print("adress: ");
    Serial.println(addressFloat);
    Serial.print("input: ");
    Serial.println(input);
    Serial.print("output: ");
    Serial.println(output);
    Serial.println("");
}

// Test reading and updating double to EEPROM
void updateAndReadDouble() { 
    Serial.println("------------------------------");     
    Serial.println("updating and retreiving double");     
    Serial.println("------------------------------");    
    
    double input  = 1000002.50;
    double output = 0.0;
    EEPROM.updateDouble(addressDouble,input);   
    output = EEPROM.readDouble(addressDouble);
    
    Serial.print("adress: ");
    Serial.println(addressDouble);
    Serial.print("input: ");
    Serial.println(input);
    Serial.print("output: ");
    Serial.println(output);
    Serial.println("");
}

// Test reading and updating a string (char array) to EEPROM
void writeAndReadCharArray() {
    Serial.println("---------------------------------");     
    Serial.println("writing and reading a char array");     
    Serial.println("---------------------------------");     
    
    char input[] = "Arduino";
    char output[] = "       ";

    EEPROM.writeBlock<char>(addressCharArray, input, 7);
    EEPROM.readBlock<char>(addressCharArray, output, 7);

    Serial.print("adress: ");
    Serial.println(addressCharArray);
    Serial.print("input: ");
    Serial.println(input);
    Serial.print("output: ");
    Serial.println(output);
    Serial.println("");
}

void writeAndReadByteArray() {

    Serial.println("---------------------------------");     
    Serial.println("updating and reading a byte array");     
    Serial.println("---------------------------------");     
    
    int itemsInArray = 7;
    byte initial[] = {1, 0, 4, 0, 16, 0 , 64 };
    byte input[]   = {1, 2, 4, 8, 16, 32, 64 };    
    byte output[sizeof(input)];

    EEPROM.writeBlock<byte>(addressByteArray, initial, itemsInArray);
    int writtenBytes = EEPROM.updateBlock<byte>(addressByteArray, input, itemsInArray);
    EEPROM.readBlock<byte>(addressByteArray, output, itemsInArray);

    Serial.print("input: ");
    for(int i=0;i<itemsInArray;i++) { Serial.print(input[i]); }
    Serial.println("");
    
    Serial.print("output: ");
    for(int i=0;i<itemsInArray;i++) { Serial.print(output[i]); }
    Serial.println("");
    
    Serial.print("Total of written bytes by update: "); 
    Serial.println(writtenBytes);    
    Serial.println("");
}

// Check how much time until EEPROM ready to be accessed
void waitUntilReady() { 
    Serial.println("-----------------------------------------------------");     
    Serial.println("Check how much time until EEPROM ready to be accessed");     
    Serial.println("-----------------------------------------------------");      
       
    Serial.print("Time after write: ");     
    EEPROM.writeLong(addressLong,10);
    
    int loops = 0;
    while (!EEPROM.isReady()) { 
       delay(1);
       loops++;
    }
    Serial.print(loops);
    Serial.print(" ms");
    Serial.println();    

    Serial.print("Time after read: ");    
    EEPROM.readLong(addressLong);
    
    loops = 0;
    while (!EEPROM.isReady()) { 
       delay(1);
       loops++;
    }
    Serial.print(loops);
    Serial.print(" ms");
    Serial.println();         
}

// Check if we get errors when writing too much or out of bounds
void errorChecking(int adress) {
    Serial.println("-------------------------------------------------------------");     
    Serial.println("Check if we get errors when writing too much or out of bounds");     
    Serial.println("-------------------------------------------------------------");   
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
  
  // start reading from position memBase (address 0) of the EEPROM. Set maximumSize to EEPROMSizeUno 
  // Writes before membase or beyond EEPROMSizeUno will only give errors when _EEPROMEX_DEBUG is set
  EEPROM.setMemPool(memBase, EEPROMSizeUno);
  
  // Set maximum allowed writes to maxAllowedWrites. 
  // More writes will only give errors when _EEPROMEX_DEBUG is set
  EEPROM.setMaxAllowedWrites(maxAllowedWrites);
  delay(100);
  Serial.println("");       
  
  // Always get the adresses first and in the same order
  addressByte      = EEPROM.getAdress(sizeof(byte));
  addressInt       = EEPROM.getAdress(sizeof(int));
  addressLong      = EEPROM.getAdress(sizeof(long));
  addressFloat     = EEPROM.getAdress(sizeof(float));
  addressDouble    = EEPROM.getAdress(sizeof(double));    
  addressByteArray = EEPROM.getAdress(sizeof(byte)*7);  
  addressCharArray = EEPROM.getAdress(sizeof(char)*7);  

  // Show adresses that have been issued
  issuedAdresses();

  // Read and write different data primitives
  readAndWriteByte(); 
  readAndWriteInt(); 
  readAndWriteLong(); 
  readAndWriteFloat();     
  updateAndReadDouble(); 

  // Read and write different data arrays
  writeAndReadCharArray();   
  writeAndReadByteArray();   
  
  // Test EEPROM access time
  waitUntilReady();
  
  // Test error checking
  errorChecking(addressLong);  
}

void loop()
{
  // Nothing to do during loop
}    