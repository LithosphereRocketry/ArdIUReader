String pathToWrite() {
  return pathToCard()+s+"ardiu-processed";
}
void setup() {
  size(1280, 720, P2D);
  surface.setTitle("ArdIU File Reader");
  surface.setResizable(true);
  load();
}
