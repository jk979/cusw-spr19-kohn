float MARGIN = 0.03;
int baseAlpha = 50;
int lnColor = 255;

class HScrollbar {
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;

  HScrollbar (float xp, float yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos + swidth/2 - sheight/2;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
  }
  
  void update() {
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 0.05) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
       mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    noStroke();
    fill(204, baseAlpha);
    rect(xpos, ypos, swidth, sheight, sheight);
    if (over || locked) {
      fill(lnColor, baseAlpha);
    } else {
      fill(102, baseAlpha);
    }
    ellipse(spos + sheight/2, ypos + sheight/2, sheight, sheight);
    fill(lnColor, 255);
    textAlign(CENTER, BOTTOM);
    text("ROTATION", xpos + swidth/2, ypos - 14);
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }
  
  float getPosPI() {
    // Convert spos to be values between
    // 0 and 2PI
    return 2 * PI * (spos-sposMin) / (swidth-sheight);
  }
}


class XYDrag {
  float scaler;
  float loose;
  
  float x_init;
  float y_init;
  float x_offset;
  float y_offset;
  float x_smooth;
  float y_smooth;
  
  float x, y;
  
  float camX_init;
  float camY_init;
  
  // Extent of Clickability
  int extentX;
  int extentY;
  int extentW;
  int extentH;
  
  XYDrag(float s, float l, int eX, int eY, int eW, int eH ) {
    scaler = s;
    loose = l;
    
    extentX = eX;
    extentY = eY;
    extentW = eW;
    extentH = eH;
  }
}
