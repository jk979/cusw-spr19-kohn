//this Person Class represents people in our class
class Person{
  String name;
  String year;
  PVector screenLocation;
  boolean locked; //am I editing my person location with mouse?
  
  //create Constructor so you can use it elsewhere
  Person(String _name,String _year){
  name = _name; //_name is what the user inputs
  year = _year; //_year is what the user inputs
  screenLocation = new PVector(width/2, height/2); //returns a person of half the width
  //and height of the screen
  }
  
  //randomly place everyone
  void randomLocation() {
    screenLocation = new PVector(random(width),random(height));
  }
  
  void drawPerson(){
    noStroke(); //no circle outline
    
    //color if hovered
    if (hoverEvent()){
      fill(#FFFF00);
    }
    else{
    fill(255); //white fill
    }
    
    ellipse(screenLocation.x, screenLocation.y, 30, 30);
    text(name + "\n" + "Year: " + year,screenLocation.x + 30, screenLocation.y + 30);
  }
  
  //is mouse cursor *near* the Person?
  boolean hoverEvent() { //boolean makes it return a true/false statement
    float xDistance = abs(mouseX - screenLocation.x); //30 = circle diameter, so half
    float yDistance = abs(mouseY - screenLocation.y);
    if (xDistance <= 15 && yDistance <= 15){
      return true;
    } else {
    return false;
    }
  }
  
  //is person selected by the mouse?
  boolean checkSelection() { 
    if (hoverEvent()) {
      locked = true;
    } else {
      locked = false;
    }
    return locked;
  }
  
  //update person location if locked on
  void update() {
    if (locked) {
      screenLocation = new PVector(mouseX, mouseY);
    }
  }
}
