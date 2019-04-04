class Block {
  //define variables:
  PVector location; //it has a location (x,y)
  PVector blockShape;   //it has a shape
  int kg;   //it has a weight
  String type;  //it has a type
  int timesCollected;   //it remembers how many times it's been collected and where it's visited
  //it senses if it's picked up
  boolean pickedUp; //if true, it's picked up by the agent; if false, it's sitting stationary somewhere

  
  
  
  
}

//block1 = new Block();

//a Bundle is made up of 4 Blocks: Paper, Plastic, Glass, and Metal. 
