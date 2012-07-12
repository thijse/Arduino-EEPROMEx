/*
 * EEPROMBackup 
 *
 * Demonstrates the usage of EEPROMvarBackup. A c++ OOP approach where a variable can store and 
 * restore itself from EEPROM. additionally it can spread the data over definable range in EEPROM memory 
 * to reduce memory wear

 * The EEPROM memory has a specified life of 100,000 write/erase cycles, 
 * so you may need to be careful about how often you write to it. 

 * Assuming you want your EEPROM to live for 100 years, you could write a location once per 9 hours. 
 * However, if you spread the information of 200 memory locations, you would be able to save every 3 minutes

 */

#include <Time.h>
#include <EEPROMex.h>
#include <EEPROMBackupVar.h>


const int maxAllowedWrites = 200;
const int memBase          = 0;
const int memCeiling       = EEPROMSizeUno;

time_t minTime = 1334102400;     // Date: 11-4-2012
time_t maxTime = 4102444800;     // Date:  1-1-2100


 // When recalling the data from EEPROM it the EEPROMBackupVar object
 // needs to figure out which item to pick. To wear we have not written
 // an additional pointer on the EEPROM pointing to the most current item 

 // Instead, using a comparison-function we try to figure out which item
 // we should fetch. Depending on the type of data you are storing you can
 // tailor this Compare function
 bool CompareFunc(const void* _current, const void* _candidate)
 {
    // Cast to the correct type
    const time_t* current   = (const time_t*) _current;
    const time_t* candidate = (const time_t*) _candidate;
      
    // check if time candidate is valid
    if (*candidate<minTime || *candidate>maxTime) {
        Serial.println("invalid time");
        return false;
    }
    // check if time candidate is more recent than previous    
    return (*candidate >= *current);
 }

// Create Eeprom variables first and in the same order
// instanciate with initial value, storage range, compare function and time between backups to EEPROM
EEPROMBackupVar<time_t> timeBackup(minTime,100,CompareFunc,1*SECS_PER_MIN);  
   
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
  
  Serial.println("retreiving time");     
  timeBackup.initialize(minTime);
  setTime(timeBackup);  
}

void loop()
{
  delay(2000);
  timeBackup=now();
  digitalClockDisplay(timeBackup);
}
  
// Display time  
void digitalClockDisplay(time_t _time){
  tmElements_t tm;   
  breakTime(_time, tm);

  Serial.print("Time: ");
  Serial.print(tm.Hour);
  Serial.print(":");
  printDigits(tm.Minute);
  Serial.print(":");
  printDigits(tm.Second);
  Serial.print(" Date: ");
  Serial.print(tm.Day);
  Serial.print(".");
  Serial.print(tm.Month);
  Serial.print(".");
  Serial.println(tm.Year+1970);
}

// utility function for digital clock display: prints preceding colon and leading 0
void printDigits(int digits){
  if(digits < 10)
    Serial.print('0');
  Serial.print(digits);
}    
