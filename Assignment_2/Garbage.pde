class Garbage{
  
  // define variables
  float x_food, y_food;
  float xpos, ypos;
  float radius = 20;
  boolean locked;
  PVector foodappear;
  PVector screenLocation; 
  PImage img;
  
  float lat_food, lon_food;
  String food_type;
    
  //constructor
  Garbage(){
    
//select a random point from the list
    xpos = random(100, width - 100);
    ypos = random(100, height - 100);
    foodappear = new PVector(xpos,ypos);
    img = loadImage("data/pizza.png");

  }
  
// functions
 void display(){
   screenLocation = map.getScreenLocation(foodappear); //converting screen into coordinates
   println(screenLocation);
   fill(0,250,0);
   image(img,xpos,ypos,width/20,height/20);
   //ellipse(xpos,ypos,radius, radius);
 }
 
void reset(){
     screenLocation = map.getScreenLocation(foodappear); //converting screen into coordinates

    println("why not print on reset");
    //print a random line from the CSV
    /*
    int randomRowReset = int(random(attributes.getRowCount()));
    println(randomRowReset);
      x_food = float(attributes.getString(randomRowReset,12));
      y_food = float(attributes.getString(randomRowReset,13))*-1;
      food_type = attributes.getString(randomRowReset,15);
      println(x_food,y_food,food_type);
    }
    */
    xpos = random(100, width - 100);
    ypos = random(100, height - 100);
}
}