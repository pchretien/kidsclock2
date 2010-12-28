/*
 * kidsclock2.pde
 */

#include <Wire.h>
#include <Time.h>
#include <TimeAlarms.h>
#include <DS1307RTC.h>

#define RED_LED 11
#define GREEN_LED 12
#define BOARD_LED 13

// 6:30 am every day
#define mh 7
#define mm 00

// 20:00 pm every day 
#define eh 20
#define em 0

int boardLedState = HIGH;

void setup()
{
  Serial.begin(9600);    
  
  setSyncProvider(RTC.get);   // the function to get the time from the RTC
  if(timeStatus()!= timeSet) 
     Serial.println("Unable to sync with the RTC");
  else
     Serial.println("RTC has set the system time"); 
     
  Alarm.alarmRepeat(mh,mm,0, MorningAlarm);  
  Alarm.alarmRepeat(eh,em,0,EveningAlarm);  
 
  InitLEDs();
}

void InitLEDs()
{
  pinMode(RED_LED, OUTPUT);  
  pinMode(GREEN_LED, OUTPUT); 
  pinMode(BOARD_LED, OUTPUT); 

  digitalWrite(RED_LED, HIGH);
  digitalWrite(GREEN_LED, LOW);
  delay(1000);
  digitalWrite(RED_LED, LOW);
  digitalWrite(GREEN_LED, HIGH);
  delay(1000);
  digitalWrite(RED_LED, LOW);
  digitalWrite(GREEN_LED, LOW);
  delay(1000);
  digitalWrite(RED_LED, HIGH);
  digitalWrite(GREEN_LED, HIGH);
  delay(1000);
  
  if( (hour() == mh && minute() >= mm ) ||
      (hour() == eh && minute() < em) ||
      (hour() > mh && hour() < eh) )
  {
    digitalWrite(RED_LED, LOW);
    digitalWrite(GREEN_LED, HIGH);    
  }
  else
  {
    digitalWrite(RED_LED, HIGH);
    digitalWrite(GREEN_LED, LOW);    
  }
}

void MorningAlarm()
{
  Serial.println("Alarm: - Morning"); 
  digitalWrite(RED_LED, LOW);
  digitalWrite(GREEN_LED, HIGH);  
}

void EveningAlarm()
{
  Serial.println("Alarm: - Evening"); 
  digitalWrite(RED_LED, HIGH);
  digitalWrite(GREEN_LED, LOW);    
}

void  loop()
{  
  boardLedState = !boardLedState;  
  digitalWrite( BOARD_LED, boardLedState);
  
  digitalClockDisplay();
  Alarm.delay(1000); // wait one second between clock display
}

void digitalClockDisplay()
{
  // digital clock display of the time
  Serial.print(hour());
  printDigits(minute());
  printDigits(second());
  Serial.println(); 
}

void printDigits(int digits)
{
  // utility function for digital clock display: prints preceding colon and leading 0
  Serial.print(":");
  if(digits < 10)
    Serial.print('0');
  Serial.print(digits);
}

