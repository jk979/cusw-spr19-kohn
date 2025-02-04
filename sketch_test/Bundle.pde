 //a Bundle is a collection of 4 blocks: plastic, paper, glass, metal. 
 class Bundle {
    float w, h;
    Block block, plastic, paper, glass, metal; //there are four blocks inside
    Block item; //for materials_inventory arraylist
    int total_kg;
    boolean pickedUp; //has it been picked up by the Agent, or is it sitting?
    int timesCollected; //remembers how many times it's been collected
    
    //constructor
    Bundle(float wpos, float hpos){
     w = wpos;
     h = hpos;

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
  
