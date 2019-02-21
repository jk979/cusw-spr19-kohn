class Agent {
  //Properties
  int capacity; //capacity for pickup: an integer
  PVector screenLocation;
  ArrayList <Float> xpos, ypos;
  String dir;
  float sidelen;
  int len;
  
  //create Constructor so you can use it elsewhere
  Agent(int _capacity){
    capacity = _capacity; //_capacity is what the user inputs
    len = 1;
    dir = "up"; //keyboard direction
    sidelen = 2;
    xpos = new ArrayList();
    ypos = new ArrayList();
    xpos.add(random(width));
    ypos.add(random(height));

    screenLocation = new PVector(width/2, height/2); //returns an Agent 
    //half width and height of screen
  
  }
  //draw the Agent
  void drawAgent(float x, float y, float a){
  pushMatrix();
  translate(x, y);
  rotate(a);
  line(0,0,segLength,0);
  popMatrix();
}

void move(){
  for (int i = len - 1; i > 0; i = i - 1){
    xpos.set(i, xpos.get(i - 1));
    ypos.set(i, ypos.get(i - 1));
  }
  if(dir == "left"){
    xpos.set(0, xpos.get(0) - sidelen);
  }
  if(dir == "right"){
    xpos.set(0, xpos.get(0) + sidelen);
  }
  if(dir == "up"){
    ypos.set(0, ypos.get(0) - sidelen);
  }
  if(dir == "down"){
    ypos.set(0, ypos.get(0) + sidelen);
  }
  xpos.set(0, (xpos.get(0) + width) % width);
  ypos.set(0, (ypos.get(0) + height) % height);
}

void display(){
  for(int i = 0; i < len; i++){
    stroke(50, 140, 198);
    fill(100,0,100, map(i-1, 0, len-1, 250, 50));
    rect(xpos.get(i), ypos.get(i), sidelen, sidelen);
  }
}

 void addLink(){
    xpos.add( xpos.get(len-1) + sidelen);
    ypos.add( ypos.get(len-1) + sidelen);
    len++;
  }
  
}
