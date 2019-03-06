color k_fill = color(255,255,0);
color mrf_fill = color(139,0,139);
color road_color = color(220,20,60);
color outline_color = color(0,255,0);
color ward_color = color(255,255,0);

void drawInfo(){
  //Rectangle
  fill(105,105,105);
  rect(width-110,height-200,200,200);
  textSize(14);
  
  fill(mrf_fill);
  text("MRF",width-105,height-170);
  fill(k_fill);
  text("Kabadiwala",width-105,height-150);
  fill(road_color);
  text("Streets", width-105, height-130);
  fill(outline_color);
  text("City Boundary",width-105,height-110);
  fill(ward_color);
  text("Ward Boundary",width-105,height-90);
  
}
