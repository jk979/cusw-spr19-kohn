//a Block can be plastic, paper, glass, or metal. 
class Block { 
  //define variables:
  
  float x, y;
  //PVector location; //it has a location (x,y)
  PVector blockShape;   //it has a shape/color
  int kg;   //it has a weight
  String type;  //it has a type
  int timesCollected;   //it remembers how many times it's been collected and where it's visited
  //it senses if it's picked up
  boolean pickedUp; //if true, it's picked up by the agent; if false, it's sitting stationary somewhere

  //constructor
  Block(float xpos, float ypos, String t, int weight){
    x = xpos;
    y = ypos;
    type = t;
    kg = weight;
  }
  
  void display(){
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
    rect(x,y,10,10);
   
}
}
