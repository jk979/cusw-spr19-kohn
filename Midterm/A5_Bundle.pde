class Block {
  //define variables:
  PVector location; //it has a location (x,y)
  PVector blockShape;   //it has a shape/color
  int kg;   //it has a weight
  String type;  //it has a type
  int timesCollected;   //it remembers how many times it's been collected and where it's visited
  //it senses if it's picked up
  boolean pickedUp; //if true, it's picked up by the agent; if false, it's sitting stationary somewhere

  //constructor
  Block(){
    location = chooseSource(); //birthed at the source
    
  }
   
}

void drawBlock(){
  fill(color(#FFFF00));
  polygon(100,100,10,10);
  }

//block1 = new Block();

//a Bundle is made up of 4 Blocks: Paper, Plastic, Glass, and Metal. 

//location = the source, in transit, at kabadiwala (can vary)
