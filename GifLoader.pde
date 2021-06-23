GifLoader SGifLoader = new GifLoader();

class GifLoader {
  private final String fmt = ".png";
  private final int digits = 4;
  private final String dFmt = "%0" + digits + "d";
  
  Gif loadGif(Gif gif, String file) {
    if(gif == null)  {
      // synchronous loading
      gif = new Gif(file);
    }
    
    if(acquiringImageFails(gif))
      return gif;
    
    createFrames(gif);
    loadFrames(gif);
    deleteFrames(gif);
    gif.start();
    return gif;
  }
  
  private boolean acquiringImageFails(Gif gif) {
    PImage target = loadImage(gif.file);
    if(target == null) {
      println("Warning: GifLoader did not find your image. Check your URL or file path.");
      return true;
    }
    
    return false;
  }
  private void createFrames(Gif gif) {
    StringList stdout = new StringList();
    StringList stderr = new StringList();
    int framesCreated;
    
    try {
      exec(stdout, stderr, "" + dataPath("ffmpeg.exe"), "-i", gif.file, "-vsync", "0",
        fileName(gif.file) + "%0" + digits + "d" + fmt);
    }
    catch(RuntimeException re) {
      re.printStackTrace();
    }
    
    framesCreated = parseFramesCreated(stderr);
    gif.frames = new PImage[framesCreated];
    gif.frameRate = parseFrameRate(stderr);
  }
  private void deleteFrames(Gif gif) {
    String name = fileName(gif.file);
    for(int i = 1; i < Math.pow(10, digits); i++) {
      String frame = String.format(name + dFmt + fmt, i);
      File fFile = new File(frame);
      if(!fFile.exists()) {
        return;
      }
      fFile.delete();
    }
  }
  private String fileName(String file) {
    file = file.substring(file.lastIndexOf("\\") + 1);
    file = file.substring(file.lastIndexOf("/") + 1);
    
    return file.split("\\.")[0];
  }
  private void loadFrames(Gif gif) {
    String name = fileName(gif.file);
    for(int i = 0; i < gif.frames.length; i++) {
      gif.frames[i] = loadImage(String.format(name + dFmt + fmt, i + 1));
    }
    try {
      gif.height = gif.frames[0].height;
      gif.width = gif.frames[0].width;
    } catch (IndexOutOfBoundsException iob) {
      println("Warning: Attempted to load gif, but didn't find or create frames. See log.");
    }
  }
  private int parseFramesCreated(StringList ffmpegOutput) {
    StringList reversedffmpegOutput = ffmpegOutput.copy();
    reversedffmpegOutput.reverse();
    
    String outputFrameLine = "";
    for(String line : reversedffmpegOutput) {
      if(line.indexOf("frame=") != -1) {
        outputFrameLine = line;
        // frame=    8 fps=5.7 q=-0.0 Lsize=N/A time=00:00:00.96 bitrate=N/A speed=0.68x
        break;
      }
    }
    
    ffmpegOutput.print();
    
    String frame = outputFrameLine.substring("frame=".length(), outputFrameLine.indexOf("fps"));
    // "    8 "
    String strFrameCount = frame.trim();
    // "8"
    
    return parseInt(strFrameCount);
  }
  private float parseFrameRate(StringList ffmpegOutput) {
    String inputStreamLine = "";
    for (String line : ffmpegOutput) {
      if(line.indexOf("fps") != -1) {
        inputStreamLine = line;
        // Stream #0:0: Video: gif, bgra, 1500x1650, 8.33 fps, 8.33 tbr, 100 tbn, 100 tbc
        break;
      }
    }
    
    String fpsCut = inputStreamLine.substring(0, inputStreamLine.lastIndexOf("fps"));
    // Stream #0:0: Video: gif, bgra, 1500x1650, 8.33 
    String[] listSplit = fpsCut.split(",");
    // ["Stream #0:0: Video: gif", " bgra", " 1500x1650"," 8.33 "]
    String strFps = listSplit[listSplit.length - 1].trim();
    // "8.33"
    
    return parseFloat(strFps);
  }
}

class GifLoaderThread extends Thread {
  private Gif gif;
  
  GifLoaderThread(Gif gifToLoad) {
    gif = gifToLoad;
  }
  
  @Override
  void run() {
    SGifLoader.loadGif(gif, gif.file);
  }
}

// API additions
Gif loadGif(String file) {
  return SGifLoader.loadGif(null, file);
}

Gif loadGifAsync(String file) {
  Gif gif = new Gif(file);
  new GifLoaderThread(gif).start();
  return gif;
}
