public float byteArrayToFloat(byte test[]) { 
    int MASK = 0xff; 
    int bits = 0; 
    int i = 3; 
    for (int shifter = 3; shifter >= 0; shifter--) { 
    bits |= ((int) test[i] & MASK) << (shifter * 8); 
    i--; 
    } 
    return Float.intBitsToFloat(bits); 
} // Credit for conversion script cadomanis of the Processing Forum. 

int b2i(byte[] from, int offs) {
  return ( from[offs    ] & 0xff       ) |
         ((from[offs + 1] & 0xff) <<  8) |
         ((from[offs + 2] & 0xff) << 16) |
         ((from[offs + 3] & 0xff)  << 24);
} // this one subpixel of the Processing Forum.

String drv = "none";
final String s = java.io.File.separator;
boolean canWrite = false;
File g;

DataPoint[][] charts = new DataPoint[0][100];

void load() {
  drv = pathToCard();
  
  if(getOS().contains("Android")) {
    println("Asking permission...");
  }
  
  if(drv != "none") { // If we found one:
    println("Found a recognized folder in drive "+drv+s+", converting flights");
    g = new File(pathToWrite());
    if(!g.exists()) {
      println("\"Processed\" folder not found, creating new one at "+g.getAbsolutePath());
      if(!g.mkdir()) {
        println("mkdir failed");
      }
    } else {
      println("\"Processed\" folder located");
    }
    for(int fileNum = 0; fileNum < 100; fileNum++) { // For each possible file number...
      charts = (DataPoint[][]) append(charts, new DataPoint[0]);
      File f = new File(drv+s+"flight"+fileNum+".aiu");
      if(f.exists()) { // Does it exist?
        PrintWriter target = createWriter(pathToWrite()+s+"flight"+fileNum+".csv");
     
        String out = csvHeader;
        byte[] file = loadBytes(f.getAbsolutePath());
        int fileVersion = b2i(file, 0); // check the version header
        for(int i = 4; i < file.length-lineSizes[fileVersion]+1; i += lineSizes[fileVersion]) {
          byte[] line = new byte[lineSizes[fileVersion]];
          arrayCopy(file, i, line, 0, lineSizes[fileVersion]);
          DataPoint lineObject = new DataPoint();
          lineObject.read(line, fileVersion);
          out += lineObject.csv();
          charts[fileNum] = (DataPoint[]) append(charts[fileNum], lineObject);
        } // If so load it
        target.flush();
        target.close();
        println("Processed file "+f.getAbsolutePath()+" to "+g.getAbsolutePath()+s+"flight"+fileNum+".csv");
      }
    }
  } else { // We didn't find a drive
    println("No recognized drive found.");
  }
}

void draw() {
  graph(0, 0, width, height, charts[0], "time", "alt");
}
