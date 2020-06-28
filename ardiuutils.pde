String toCSV(byte[] file) {
  String out = "";
  
  int fileVersion = b2i(file, 0); // check the version header
  switch(fileVersion) {
   case 3:
    out += "Time (ms),Altitude (m),Acceleration X (G),Acceleration Y (G),Acceleration Z (G),Tilt (rad),Battery voltage (V),Liftoff,Burnout,Apogee,Continuity,IMU/SD/Baro\n";
    for(int filePos = 4; filePos < file.length-27; filePos += 28) {
      int time = b2i(file, filePos); // read the time
      int state = b2i(file, filePos+4);
      float voltage = (state & 255) / 16.0;
      String cont = "";
      for(int i = 0; i < 8; i++) {
        if((state & (1 << 8+i)) > 0) {
          cont += 'Y';
        } else {
          cont += 'n';
        }
      }
      String system = "";
      for(int i = 0; i < 3; i++) {
        if((state & (1 << 16+i)) > 0) {
          system += 'Y';
        } else {
          system += 'n';
        }
      }
      boolean liftoff = (state & (1 << 24)) > 0;
      boolean burnout = (state & (1 << 25)) > 0;
      boolean apogee = (state & (1 << 26)) > 0;
      byte[] altBytes = new byte[4]; // read the altitude
      arrayCopy(file, filePos+8, altBytes, 0, 4);
      float alt = byteArrayToFloat(altBytes);
      byte[] accXBytes = new byte[4]; // read the acceleration
      arrayCopy(file, filePos+12, accXBytes, 0, 4);
      float accX = byteArrayToFloat(accXBytes);
      byte[] accYBytes = new byte[4]; // read the acceleration
      arrayCopy(file, filePos+16, accYBytes, 0, 4);
      float accY = byteArrayToFloat(accYBytes);
      byte[] accZBytes = new byte[4]; // read the acceleration
      arrayCopy(file, filePos+20, accZBytes, 0, 4);
      float accZ = byteArrayToFloat(accZBytes);
      byte[] tiltBytes = new byte[4]; // read the acceleration
      arrayCopy(file, filePos+24, tiltBytes, 0, 4);
      float tilt = byteArrayToFloat(tiltBytes);
      out += time+","+alt+","+accX+","+accY+","+accZ+","+tilt+","+voltage+","+liftoff+","+burnout+","+apogee+","+cont+","+system+"\n"; // write it all to the file
    }
    break;
   
   case 2:
    out += "Time (ms),Altitude (m),Acceleration X (G),Acceleration Y (G),Acceleration Z (G),Tilt (rad)\n";
    for(int filePos = 4; filePos < file.length-23; filePos += 24) {
      int time = b2i(file, filePos); // read the time
      byte[] altBytes = new byte[4]; // read the altitude
      arrayCopy(file, filePos+4, altBytes, 0, 4);
      float alt = byteArrayToFloat(altBytes);
      byte[] accXBytes = new byte[4]; // read the acceleration
      arrayCopy(file, filePos+8, accXBytes, 0, 4);
      float accX = byteArrayToFloat(accXBytes);
      byte[] accYBytes = new byte[4]; // read the acceleration
      arrayCopy(file, filePos+12, accYBytes, 0, 4);
      float accY = byteArrayToFloat(accYBytes);
      byte[] accZBytes = new byte[4]; // read the acceleration
      arrayCopy(file, filePos+16, accZBytes, 0, 4);
      float accZ = byteArrayToFloat(accZBytes);
      byte[] tiltBytes = new byte[4]; // read the acceleration
      arrayCopy(file, filePos+20, tiltBytes, 0, 4);
      float tilt = byteArrayToFloat(tiltBytes);
      out += time+","+alt+","+accX+","+accY+","+accZ+","+tilt+"\n"; // write it all to the file
    }
    break;
   case 1: // File format 1: time[int32] alt[float32] acc[float32]
    out += "Time (ms),Altitude (m),Acceleration (G)\n";
    for(int filePos = 4; filePos < file.length; filePos += 12) {
      int time = b2i(file, filePos); // read the time
      byte[] altBytes = new byte[4]; // read the altitude
      arrayCopy(file, filePos+4, altBytes, 0, 4);
      float alt = byteArrayToFloat(altBytes);
      byte[] accBytes = new byte[4]; // read the acceleration
      arrayCopy(file, filePos+8, accBytes, 0, 4);
      float acc = byteArrayToFloat(accBytes);
       out += time+","+alt+","+acc+"\n"; // write it all to the file
    }
    break;
   case 0: // File format 0: time[int32] alt[float32]
   default: // Default for unrecognized formats
    out += "Time (ms),Altitude (m)\n";
    for(int filePos = 4; filePos < file.length; filePos += 12) {
      int time = b2i(file, filePos); // read the time
      byte[] altBytes = new byte[4]; // read the altitude
      arrayCopy(file, filePos+4, altBytes, 0, 4);
      float alt = byteArrayToFloat(altBytes);
      out += time+","+alt+"\n";
    }
  }
  return out;
}