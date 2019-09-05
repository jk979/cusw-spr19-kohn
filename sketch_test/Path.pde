//build toy model with the bundle, household, path, kabadiwala, MRF, and wholesaler. Have this ready for Nina by tomorrow. 

 class Path {
 
//A Path is now an ArrayList of points (PVector objects).
  ArrayList<PVector> points;
  float radius;
 
  Path() {
    radius = 20;
    points = new ArrayList<PVector>();
  }
 
//This function allows us to add points to the path.

  void addPoint(float x, float y) {   
    PVector point = new PVector(x,y);
    points.add(point);
  }

//Display the path as a series of points.

  void display() {
    stroke(200,200,200);
    noFill();
    beginShape();
    for (PVector v : points) {
      vertex(v.x,v.y);
    }
    endShape();
  }

}
