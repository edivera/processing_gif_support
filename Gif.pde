class Gif extends PImage implements Runnable {
  public String file;
  public PImage[] frames;
  public float frameRate;
  public boolean pause = false;
  
  private boolean alive = false;
  private int current = 0;
  
  public Gif() {
    if(sLoadingFrame == null)  sLoadingFrame = loadImage("loading.png");
    this.height = 100;
    this.width = 100;
  }
  public Gif(String _file) {
    this();
    if(!_file.startsWith("http"))
      file = dataPath(_file);
    else file = _file;
  }
  
  @Override
  public PImage get() {
    if(!alive) return sLoadingFrame;
    return frames[current];
  }
  public int getCurrentFrame() {
    return current;
  }
  public void start() {
    if(!alive) {
      alive = true;
      Thread t = new Thread(this);
      t.start();
    }
  }
  public void stop() {
    alive = false;
  }
  
  @Override
  void run() {
    int microPeriod = int(1.0 / this.frameRate * 1000);
    while(alive) {
      if(!pause) {
        delay(microPeriod);
        next();
      }
    }
  }
  
  private void next() {
    current = (current + 1) % frames.length;
  }
}

PImage sLoadingFrame;

// API Modifications
@Override
void image(PImage img, float a, float b) {
  super.image(img.get(), a, b);
}

@Override
void image(PImage img, float a, float b, float c, float d) {
  super.image(img.get(), a, b, c, d);
}

@Override
void image(PImage img, float a, float b, float c, float d,
           int u1, int v1, int u2, int v2) {
  super.image(img.get(), a, b, c, d, u1, v1, u2, v2);
}
