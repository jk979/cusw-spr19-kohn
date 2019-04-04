//Main display
Block plastic, glass, metal, paper;
Bundle bundle;
int total_kg;

void setup(){
  size(640, 360);
  noStroke();
  
  bundle = new Bundle(width*0.45, height*0.45);
}

void draw(){
  background(0);

  bundle.displayBundle();
  
  text("Plastic: "+plastic.kg,100,100);
  text("Paper: "+paper.kg, 100, 120);
  text("Glass: "+glass.kg, 100, 140);
  text("Metal: "+metal.kg, 100, 160);
  text("Bundle total: "+bundle.total_kg, 100, 180);
  
}
