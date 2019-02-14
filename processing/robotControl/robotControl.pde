import processing.serial.*;
Serial myPort;
Robot bob;
float magic = 1024/300; // number used for conversion of angle to step


// TODO: det er noe feil med vinkelen på servoene når de skal den andre vieien.


//int SMOOTH_STEPS = 1000;
// *************************************************************************************************
// *************************************************************************************************
// *********************** Processing build in methods *********************************************

void setup() 
{
    // The "main program" in this example
    
    // window size - window not used
    size(640, 360);
    
    // print serial list
    for (int i = 0; i < Serial.list().length; i++) {
      println(Serial.list()[i]);
    }

    // 1Mbit transfer rate over COM8
    String port_name = Serial.list()[Serial.list().length-1];
    println("Checking port: " + port_name);
    myPort = new Serial(this, port_name, 1000000);
  
    print("port available: " + myPort.available() + "\n");
    bob = new Robot();
    
    // Some examples, just to see how it can be done

    // Configure a new ID to a servo on the bus:
    // (only one servo can be on the bus during this broadcast instruction)
    // setReg1(254, 3, id);
    
    // LED on/off: Set servo LED on/off: 
    // setReg1(1, 25, 1);
    
    // Simple move: Move one servo, angle(0-1023), speed(0-1023): 
    // setReg2(id, 32, speed); setReg2(id, 30, angle);
    
    // Ping: 
    // sendCmd(id, 1);
    
    // Reset: resets all registers to factory configuration, do so it if messed up:
    // For some unknown reason it may not reset everything to default values...
    // sendCmd(id, 6);  
  
  // Verbose response off
    // setReg1(1, 16, 0);
    
    // Set max/min angle: limit the angular range (0-1024). 
    // Also use this to select "wheel mode" / "joint mode", maxAngle = minAngle = 0 gives "wheel mode"
    // setReg2(id, 6, minAngle); setReg2(id, 8, maxAngle)
    
    // Read temp: read internal servo temperature in Celsius 
    // regRead(id, 43, 1);
}

void draw() 
{
    // infinite loop, not used in this example
    background(51);
    bob.update();
}

void keyPressed() 
{
    // event based keyboard input example
    
    if (key == 'x') 
        setReg1(2, 32, 222);      
    else if (key == 'r')
        bob.reset_servos();
    else if (key == 'w')
        bob.move_forward();
    else if (key == 's')
        bob.tilt_other();
    else if (key == 'e')
        bob.forward_to_reset();
    else if (key == 'd')
        bob.turn_right();
    else if (key == 'a')
        bob.turn_left();
}
/*
void serialEvent(Serial p) 
{ 
    // Handles bytes back from servo (status packet) if you like it event based
    // Otherwise comment out this event based method and use "myPort.read()" from your other methods
    
    int in = p.read(); 
    //print(" " + in); // DEC
    print(" " + hex(in, 2)); // HEX
} 
*/
// *************************************************************************************************
// *************************************************************************************************
// ******* Dynamixel bareBone methods **************************************************************

// ======================= Writes 0<val<255 to register "regNo" in servo "id" ======================

void setReg1(int id, int regNo, int val)
{
    byte b[] = { 
        (byte)0xFF, (byte)0xFF, (byte)0, (byte)0, (byte)3, (byte)0, (byte)0, (byte)0
    }; 

    b[2] = (byte)id;
    b[5] = (byte)regNo;
    b[6] = (byte)val;

    b = addChecksumAndLength(b); 
    //printOutPacketToConsole(b); (not included) 
    myPort.write(b);
}

// ======================= Writes 0<val<1023 to register "regNoLSB/regNoLSB+1" in servo "id" =======

void setReg2(int id, int regNoLSB, int val)
{
    byte b[] = { 
        (byte)0xFF, (byte)0xFF, (byte)0, (byte)0, (byte)3, (byte)0, (byte)0, (byte)0, (byte)0
    }; 

    b[2] = (byte)id;
    b[5] = (byte)regNoLSB;
    b[6] = (byte)( val & 255 );
    b[7] = (byte)( (val >> 8) & 255 );

    b = addChecksumAndLength(b); 
    //printOutPacketToConsole(b); (not included) 
    myPort.write(b);
}

// ======================= read from register, status packet printout is handled by serialEvent() ==

void regRead(int id, int firstRegAdress, int noOfBytesToRead)
{
    println(" "); // console newline before serialEvent() printout

    byte b[] = { 
        (byte)0xFF, (byte)0xFF, (byte)0, (byte)0, (byte)2, (byte)0X2B, (byte)0X01, (byte)0
    }; 

    b[2] = (byte)id;
    b[5] = (byte)firstRegAdress;
    b[6] = (byte)noOfBytesToRead;

    b = addChecksumAndLength(b); 
    //printOutPacketToConsole(b); (not included) 
    myPort.write(b); 
}

// ======================= Sends a 1 byte command to servo id ======================================

void sendCmd(int id, int cmd)
{
    byte b[] = { 
        (byte)0xFF, (byte)0xFF, (byte)0, (byte)0, (byte)0, (byte)0
    }; 

    b[2] = (byte)id;
    b[4] = (byte)cmd;

    b = addChecksumAndLength(b); 
    //printOutPacketToConsole(b); (not included) 
    myPort.write(b);
}

// ======================= adds checksum and length bytes to the ASCII byte packet =================

byte[] addChecksumAndLength(byte[] b)
{
    // adding length
    b[3] = (byte)(b.length - 4);

    // finding sum
    int teller = 0;
    for (int i=2; i<(b.length-1); i++)
    {
        int tmp = (int)b[i];
        if (tmp < 0) 
            tmp = tmp + 256;
        teller = teller + tmp;
    }

    // inverting bits
    teller = ~teller;
    // int2byte 
    teller = teller & 255;

    // adding checkSum
    b[b.length-1] = (byte)teller;

    return b;
}

// ======================= just plain Java - pauses current thread =================================

void pause(int ms)
{
    try 
    {
        Thread.currentThread().sleep(ms);
    }
    catch(Exception ie) 
    {
        // whatever you like to complain about
    }
}