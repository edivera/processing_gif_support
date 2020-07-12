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
    file = dataPath(_file);
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

// API Additions
void image(Gif gif, float a, float b) {
  image(gif.get(), a, b);
}

void image(Gif gif, float a, float b, float c, float d) {
  image(gif.get(), a, b, c, d);
}

void image(Gif gif,
                  float a, float b, float c, float d,
                  int u1, int v1, int u2, int v2) {
  image(gif.get(), a, b, c, d, u1, v1, u2, v2);
}
