/*
 * EEPROM Read
 *
  * The EEPROM memory has a specified life of 100,000 write/erase cycles, 
  * so you may need to be careful about how often you write to it. 

  * Assuming you want your EEPROM to live for 100 years, you could write a location once per 9 hours. 
  * However, if you spread the information of 200 memory locations, you would be able to save every 3 minutes

 * Reads the value of each byte of the EEPROM and prints it
 * to the computer.
 * This example code is in the public domain.
 */

#include <Time.h>
#include <EEPROMex.h>
#include <EEPROMBackupVar.h>

// start reading from the first byte (address 0) of the EEPROM

const int maxAllowedWrites = 200;
const int memBase          = 0;
const int memCeiling       = EEPROMSizeUno;

time_t minTime = 1334102400;     // Date: 11-4-2012
time_t maxTime = 4102444800;     // Date:  1-1-2100


 // comparison-function 
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


EEPROMBackupVar<time_t> timeBackup(minTime,100,CompareFunc,1*SECS_PER_MIN);  
   
void setup()
{
  Serial.begin(9600);
  EEPROM.setMemPool(memBase, memCeiling, EEPROMSizeUno);
  EEPROM.setMaxAllowedWrites(maxAllowedWrites);
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

void printDigits(int digits){
  // utility function for digital clock display: prints preceding colon and leading 0
  Serial.print(":");
  if(digits < 10)
    Serial.print('0');
  Serial.print(digits);
}    
