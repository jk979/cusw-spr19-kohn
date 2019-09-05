//Main display
Block plastic, glass, metal, paper;
Bundle bundle1, bundle2, bundle3;
boolean square; //hit a key to change the shape/size of the bundle

float x = 250; 
float y = 250;

//global quantities
int wt_plastic = 50;
int wt_paper = 20;
int wt_glass = 30;
int wt_metal = 145;

ArrayList<Way> ways = new ArrayList<Way>();
Path linetest = new Path();
Path HHtoKabadiwala = new Path();
Path KabadiwalaToMRF = new Path();

ArrayList<Bundle> bundleArray = new ArrayList();
ArrayList<KabadiwalaAgent> kabadiwalaArray = new ArrayList();

void setup(){
  size(640, 360);

  noStroke();
  
  for(int i=0; i<5; i++){
    Bundle b = new Bundle((int)random(width),(int)random(height));
    bundleArray.add(b);
  }
  
  for(int i=0; i<5; i++){
    KabadiwalaAgent k = new KabadiwalaAgent((int)random(width),(int)random(height));
    kabadiwalaArray.add(k);
  }
  //make an arraylist of the bundles
  //bundle1 = new Bundle(width*0.45, height*0.45); //initialize Bundle
  //bundle2 = new Bundle(width*0.7, height*0.7);
  //bundle3 = new Bundle(width*0.2, height*0.2);
  
  //add first path
  HHtoKabadiwala.addPoint(200,200);
  HHtoKabadiwala.addPoint(300,200);
  HHtoKabadiwala.addPoint(400,200);
  println(HHtoKabadiwala);
  
  
  //add second path
  KabadiwalaToMRF.addPoint(400,200);
  KabadiwalaToMRF.addPoint(500,300);
  
  //Way way = new Way(HHtoKabadiwala);
  //ways.add(way); 
}
  
void draw(){
  background(0);
  //ways.HH_paths = true;
  
  //display the array of bundles
  for(int i = 0; i<bundleArray.size(); i++){
    Bundle Bn = (Bundle) bundleArray.get(i);
    Bn.display();
    text("Weight: "+Bn.total_kg,Bn.w,Bn.h);
  }
  
  for(int i = 0; i<kabadiwalaArray.size(); i++){
    KabadiwalaAgent k = (KabadiwalaAgent) kabadiwalaArray.get(i);
    k.display();
  }
  //display paths
  HHtoKabadiwala.display();
  KabadiwalaToMRF.display();
  
  //display one agent
  //fill (0, 175, 255);
  //smooth ();
  //noStroke();
  //render();
  

  
  
  
  
  
  /*
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
  */
}

void mousePressed() {
  //bundle1.timesCollected++;
  //bundle3.pickedUp = true;
  square = false;
}

void keyPressed() {
  if(key=='f'){
  //bundle2.timesCollected++;
  }
  else if(key=='g'){
  //bundle3.pickedUp = !bundle3.pickedUp;
  }
  else if(key=='z'){
  square = !square;
  }
  else if(key == CODED) {
    if (keyCode == LEFT) {
      x = x - 10;
      direction = -1;
      direction2 = 0;
    }
    else if (keyCode == RIGHT) {  
      x = x + 10;
      direction = 1;
      direction2 = 0;
    }
    else if (keyCode == UP) {
      y = y - 10;
      direction = 0;
      direction2 = -1;
    }
    else if (keyCode == DOWN) { 
      y = y + 10;
      direction = 0;
      direction2 = 1;
    }
  }
}
