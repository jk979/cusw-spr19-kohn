color poi_fill = color(255, 99, 71); //any point color
color restaurant = color(255, 255, 0); //if poi is restaurant
color mit = color(32, 178, 170); 
color polygon_fill = color(32, 255, 170);
color road_color = color(100, 149, 237);
color food_fill = color(0,250,0); //food color

void drawInfo(){ 
  //Rectangle
  fill(0);
  rect(20, 20, 125, 125);
  textSize(16);
  //POI
  fill(poi_fill);
  text("poi", 25, 40);
  //Free Food
  fill(food_fill);
  text("free food", 25, 60);
  //Restaurant
  fill(restaurant);
  text("Restaurants!", 25, 80);
  fill(road_color);
  text("Roads", 25, 100);
  fill(polygon_fill);
  text("Buildings", 25, 120);
}
