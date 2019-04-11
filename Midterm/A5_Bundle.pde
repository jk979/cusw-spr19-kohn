////////////// BLOCK ////////////////
boolean square; //hit a key to change the shape/size of the bundle

 //a Block can be plastic, paper, glass, or metal. 
class Block { 
  //PVector location; //it has a location (x,y)
  //basic properties
  float x, y;
  PVector location, loc;
  float kg;   //it has a weight
  String type;  //it has a type
  
  //transit properties
  boolean pickedUp; //if true, it's picked up by the agent; if false, it's sitting stationary somewhere
  int timesCollected;   //it remembers how many times it's been collected and where it's visited
  
  //tracking movement time through system
  int timePlaced; //time placed at source
  int timeTransit1; //time in transit from source to kabadiwala (stage 1)
  int timeK; //time waiting at kabadiwala
  int timeTransit2; //time in transit from kabadiwala to MRF or kabadiwala to Wholesaler (stage 2)
  int timeMRF; //time waiting at MRF
  int timeW; //time waiting at wholesaler
    
  //constructor
  Block(String t, float weight){
    type = t;
    kg = weight;
    loc = location;
  }
  
  void display(float x,float y){ //give block shape/color
    if(type == "plastic"){
    fill(color(#FFFF00));
    }
    else if(type == "glass"){ 
      fill(color(#00FF00));
    }
    else if(type == "metal"){
      fill(color(#FF0000)); 
    }
    else if(type == "paper"){
      fill(color(#FFFFF0));
    }
    if(square==true){
    rect(x,y,10,10);
    }
    else if(square==false){
    ellipse(x,y,4,4);
    }
}
}

////////////////////////// BUNDLE ////////////////////////

 //a Bundle is a collection of 4 blocks: plastic, paper, glass, metal. 
 class Bundle {
    //basic properties
    int id;
    float w, h;
    PVector location,loc;
    Block block, plastic, paper, glass, metal; //there are four blocks inside
    Block item; //for materials_inventory arraylist
    float total_kg;
    
    //transit properties
    boolean pickedUp; //if true, it's picked up by the agent; if false, it's sitting stationary somewhere
    int timesCollected;   //it remembers how many times it's been collected and where it's visited
    
    //tracking movement time through system
    int timePlaced; //time placed at source
    int timeTransit1; //time in transit from source to kabadiwala (stage 1)
    int timeK; //time waiting at kabadiwala
    int timeTransit2; //time in transit from kabadiwala to MRF or kabadiwala to Wholesaler (stage 2)
    int timeMRF; //time waiting at MRF
    int timeW; //time waiting at wholesaler
      
    //constructor
    Bundle(PVector location){
     w = location.x;
     h = location.y;
     loc = location;
     id = id;
     
     plastic = new Block("plastic", wt_plastic);
     paper = new Block("paper", wt_paper);
     glass = new Block("glass", wt_glass);
     metal = new Block("metal", wt_metal);
     
     //add all these to the materials inventory list
     ArrayList<Block> materials_inventory = new ArrayList<Block>();
     materials_inventory.add(paper);
     materials_inventory.add(plastic);
     materials_inventory.add(glass);
     materials_inventory.add(metal);  
     
     //total weight of all items
     total_kg = plastic.kg + paper.kg + glass.kg + metal.kg;     
     
  }
  
  void display(){
    
    if(square == true){
    //draw all four blocks
    noStroke();
    plastic.display(w,h);
    paper.display(w+12,h);
    glass.display(w,h+12);
    metal.display(w+12,h+12);
    
    //draw a border around the four blocks to show that they're bundled
    noFill();
    strokeWeight(2);
    stroke(#FFFFFF,255);
    rect(w-5, h-5, 30, 30);
    }
    
    else if(square == false){
    //draw all four blocks
    noStroke();
    plastic.display(w,h);
    paper.display(w+2,h);
    glass.display(w,h+2);
    metal.display(w+2,h+2);
    
    //draw a border around the four blocks to show that they're bundled
    noFill();
    strokeWeight(1);
    stroke(#FFFFFF,255);
    ellipse(w,h,10,10);
    }
    
  }
  
 }
 
 
  
