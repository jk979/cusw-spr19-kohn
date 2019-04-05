//Main display
Block plastic, glass, metal, paper;
Bundle bundle1, bundle2, bundle3;
boolean square; //hit a key to change the shape/size of the bundle

//global quantities
int wt_plastic = 50;
int wt_paper = 20;
int wt_glass = 30;
int wt_metal = 145;


void setup(){
  size(640, 360);
  noStroke();
  bundle1 = new Bundle(width*0.45, height*0.45); //initialize Bundle
  bundle2 = new Bundle(width*0.7, height*0.7);
  bundle3 = new Bundle(width*0.2, height*0.2);
}

void draw(){
  background(0);

  bundle1.display();
  bundle2.display();
  bundle3.display();  
  //println(bundle1.w,bundle1.h);
  //must access the locations of each individual material
  //println(bundle1.plastic.display(w,h));
  
  //access an individual bundle's plastic  
  text("Bundle 1 Plastic: "+bundle1.plastic.kg,100,120);
  text("Bundle 1 Paper: "+bundle1.paper.kg, 100, 140);
  text("Bundle 1 Glass: "+bundle1.glass.kg, 100, 160);
  text("Bundle 1 Metal: "+bundle1.metal.kg, 100, 180);
  
  text("Bundle 1 total: "+bundle1.total_kg, 100, 200);
  text("Bundle 2 total: "+bundle2.total_kg, 100, 220);
  text("Bundle 3 total: "+bundle3.total_kg, 100,240);
  
  //all these properties work
  text("Bundle 1 times collected: "+bundle1.timesCollected, 100, 280);
  text("Bundle 2 times collected: "+bundle2.timesCollected, 100, 300);
  text("Bundle 3 picked up? "+bundle3.pickedUp, 100, 320);
}

void mousePressed() {
  bundle1.timesCollected++;
  bundle3.pickedUp = true;
  square = false;
}

void keyPressed() {
  if(key=='f'){
  bundle2.timesCollected++;
  }
  else if(key=='g'){
  bundle3.pickedUp = !bundle3.pickedUp;
  }
  else if(key=='z'){
  square = !square;
  }
}
