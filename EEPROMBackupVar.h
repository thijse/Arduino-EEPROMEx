#ifndef EEPROMBACKUP_h
#define EEPROMBACKUP_h

#if ARDUINO >= 100
#include <Arduino.h> 
#else
#include <WProgram.h> 
#endif
#include <EEPROMex.h>
#include <Time.h>        //http://www.arduino.cc/playground/Code/Time

/*
  EEPROMBackupvar.h - EEPROM variable library
  Copyright (c) 2012 Thijs Elenbaas.  All right reserved.
  
  based on class by AlphaBeta

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

typedef bool (*compareFunction)(const void*, const void*);                       

template<typename T> class EEPROMBackupVar 
{
	public:
	  EEPROMBackupVar(T init, int range, compareFunction compareFunc,unsigned long time=0) {
		adressRange = range;
		timeBetweenSaves = time*1000; // from sec to milisec
		baseAddress = EEPROM.getAdress(sizeof(T)*adressRange);	
		function = compareFunc;
		position = -1;		
		var = init;		
	  }
	  	 	
	  void initialize(T init){	    
		baseAddress = EEPROM.getAdress(sizeof(T)*adressRange);
		retreive(init);	
	  }				
			  
			  
	  operator T () { 
		return var; 
	  }	  
	  EEPROMBackupVar &operator=(T val) {
		var = val;
		saveIfDue();
	  }	  
	  void operator+=(T val) {
		var += T(val); 
		saveIfDue();
	  }
	  void operator-=(T val) {
		var -= T(val); 
		saveIfDue();
	  }	 	  
	  void operator++(int) {
		var += T(1); 
		saveIfDue();
	  }
	  void operator--(int) {
		var -= T(1);
		saveIfDue();		
	  }
	  void operator++() {
		var += T(1); 
		saveIfDue();
	  }
	  void operator--() {
		var -= T(1);
		saveIfDue();		
	  }
	  template<typename V>
		void operator /= (V divisor) {
		var = var / divisor;
		saveIfDue();
	  }
	  template<typename V>
		void operator *= (V multiplicator) {
		var = var * multiplicator;
		saveIfDue();
	  }	  
	  void saveIfDue(){	   	   
	    // Save after if a certain time has passed        
		unsigned long currentTime = millis();	
	
		if (timeBetweenSaves>0) {
		    if (currentTime<latestupdatedTime) {latestupdatedTime = currentTime; }
			if ((currentTime- latestupdatedTime)>timeBetweenSaves) {				
				latestupdatedTime = currentTime; 
				save();				
			}
		}
	  }	  
	  void save(){	   	   
        nextPosition();
		EEPROM.updateBlock<T>(address(position), var);
		Serial.print("save at position ");
		Serial.println(position);		
	  }	  	 
	  void restore(){
		if (position>=0) {
			Serial.print("read at position ");
			Serial.println(position);	  
			EEPROM.readBlock<T>(address(position), var);
		}
	  }
	  
	  void retreive(T init){	    
	    T currentValue;
		T candidateValue;	
		position = 0;
		var = init;		
		// Loop through all stored locations to see which one is the most up to date
		for(int i=0;i<adressRange; i++) { 
			EEPROM.readBlock<T>(address(i), candidateValue);
			if (i==0) { currentValue = candidateValue; }
			if (compare(currentValue,candidateValue)) {
				position = i;
				var = candidateValue;
			}
		}		
		Serial.print("fetched value ");
		Serial.print(var);
		Serial.print(" from position ");
		Serial.println(position);			
	  }	  
	  
	  void clearMemory(T init){	    
	
		// Loop through all stored locations and save initialize value
		for(int i=0;i<adressRange; i++) { 
		    Serial.print("save at position ");
			Serial.println(i);
			EEPROM.writeBlock<T>(address(i), init);
		}		
		Serial.print("fetched value ");
		Serial.print(var);
		Serial.print(" from position ");
		Serial.println(position);			
	  }	  

	  
	  
	protected:
	  int address(int position) {
		return baseAddress + sizeof(T)*position;
	  }
	  
      void nextPosition() {
	  	position++;
		if (position>=adressRange) { position=0; }
	  }
	  
	  bool compare(T current, T candidate) {
		return function(&current, &candidate);
	  }
	
	  T var;
	  int baseAddress;
	  int adressRange;
	  int position;
	  unsigned long timeBetweenSaves;
	  unsigned long latestupdatedTime;
	  compareFunction function;
};

#endif



