 class Bundle {
    float x, y;
    Block block; //there are four blocks inside
    int total_kg;
    
    //constructor
    Bundle(float xpos, float ypos){
     x = xpos;
     y = ypos;
     
     //weight the bundle
     plastic = new Block(width*0.45, height*0.5, "plastic", 2);
     paper = new Block(width*0.45+12, height*0.5, "paper", 4);
     glass = new Block(width*0.45, height*0.5+12, "glass", 6);
     metal = new Block(width*0.45+12, height*0.5+12, "metal", 8);
     
     //total weight of all items
     total_kg = plastic.kg + paper.kg + glass.kg + metal.kg;
  }
  
  void displayBundle(){
    
    noStroke();
    plastic.display();
    paper.display();
    glass.display();
    metal.display();
    
    //draw a border around the four objects
    noFill();
    strokeWeight(2);
    stroke(#FFFFFF,255);
    rect(width*0.45-5, height*0.5-5, 30, 30);
    
  }
  
 }
  
