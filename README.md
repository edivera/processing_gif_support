## Tutorial
~~~
Gif myGif;
Gif myOtherGif;

void setup() {
    size(500, 250);
    myGif = loadGifAsync("path/to/your.gif");  // will load the gif without blocking
    myOtherGif = loadGif("path/to/your.gif");  // will load the gif on demand
    imageMode(CORNER);	// not limited to this imageMode ofc
}

void draw() {
    image(myGif, 0, 0);  // will draw gif with top left corner at 0, 0
    image(myOtherGif, 0, 250, 250, 250);  // will draw 250x250 gif with top left corner at 250, 0
    
    // your other processing image() API also included
    // image(myGif, a, b, c, d, u1, v1, u2, v2);
}
~~~