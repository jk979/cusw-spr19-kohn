//Step 1: Create/allocate memory for the Person
ArrayList<Person> people; //make Person into an editable list of items //Nodes
ArrayList<Connection> friends; //Edges

//Runs once
void setup() {
  size(800,600); //screen size of 800x600
  initialize();
  //background(0); //make black background
  //ira = new Person("Ira", "Old");
  people = new ArrayList<Person>();
  friends = new ArrayList<Connection>();
  
  for(int i=0; i<10; i++){
    Person p = new Person("Person" + i, str(int((random(1, 5))))); //adds the person's name 
    //plus a random year
    p.randomLocation();
    people.add(p);
  }
  
  //who are the friends?
  for (Person origin: people) {
    for (Person destination: people) {
      //is person referencing themselves?
      if (!origin.name.equals(destination.name)) {
        //are origin and destination the same year?
          if (origin.year.equals(destination.year)) {
            friends.add(new Connection(origin, destination, "friends"));
            }
        }
     }
  }

println(friends.size());
}

//Runs again and again at 60fps
void draw(){
  background(0); //putting background here means the ellipse won't make a worm
  fill(255);
  //ellipse(mouseX,mouseY,50,50); 
  //draw Ira using the Person class function
  for (Person p: people) { 
    p.update(); //updates location if selected
    p.drawPerson();
  }
  //draw connections
  for (Connection c: friends) {
    c.draw();
    }
}

void mousePressed() {
  //background(#FF0000,100); //flash when mouse pressed
  for (Person p: people) {
    if(p.checkSelection()){
      break;
    }
  }
}

void mouseReleased(){
  for (Person p: people){
    p.locked = false;
  }
}

void initialize() {
  people = new ArrayList<Person>();
  friends = new ArrayList<Connection>();
}

void keyPressed(){
  initialize();
}
