Gif gif;

void setup() {
  size(500, 500);
  //gif = loadGif("example-gif-bryanunger.com.gif");  // waiting load
  gif = loadGifAsync("example-gif-bryanunger.com.gif");  // asynchronous load
  imageMode(CORNER);
}

void draw() {
  background(29, 46, 86);
  drawGif();
}

void drawGif() {
  image(gif, 0, 0, 500, 500);
}
