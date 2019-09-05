//19.0942, 19.0391, 72.8462, 72.8143

float MARGIN = 0.03;
int baseAlpha = 50;
int lnColor = 255;

color colorBuildingResidential = color(0,0,0);
color colorCoastline = color(128,128,128);
color colorRail = color(255,170,170);
color colorStreet = color(105,105,105); //dark gray (64,70,77,100) //blue: (0,200,255,100)
color colorWaterway = color(0,0,255); 
color colorRailways = color(255,170,170);
color mrf_fill = color(255,255,0); //MRF points (yellow)
color k_fill = color(34, 200, 34); //Kabadiwala shops(green)
color w_fill = color(0,200,255);
color colorWardBounds = color(128,128,128);
color colorHHPaths = color(255,211,0);
color colorMRFPaths = color(230,45,10);
color stoppedAgent = color(230,230,230);

void drawInfo(){
  text(frameRate, 25, 25);
  
  //draw title box
  int bgColor = 230;
  noStroke();
  fill(105,105,105);
  rect(520,20,700,120,10);
  //draw title text
  fill(255,255,255);
  textSize(24);
  text("Journey Through Mumbai's Recycling System", 540, 50);
  //draw description
  fill(240,240,240);
  textSize(12);
  text("Kabadiwalas are the informal recycling heroes of Mumbai, India. \nThey collect recyclable plastic, paper, glass, and metal from households and sell it up the value chain.",540,70);
  fill(255,255,255);
  text("Kabadiwala ", 550,110);
  fill(k_fill);
  ellipse(540,105,7,7);
  fill(255,255,255);
  text("MRF Collector ", 550,120);
  fill(mrf_fill);
  ellipse(540,115,7,7);
  fill(255,255,255);
  text("Wholesaler Collector ", 550,130);
  fill(w_fill);
  ellipse(540,125,7,7);
  fill(255,255,255);
  text("By Jacob Kohn", 1100,50);
  //draw input box
  stroke(105,105,105);
  fill(105,105,105); 
  rect(520, 150, 300, 550, 10);
  //draw input title
  textSize(16);
  rect(520,150,300,50,10);
  fill(255,69,0);
  text("Inputs",650,180);
  fill(255,255,255);
  //draw input content
  textSize(12);
  text("Kabadiwalas in System: "+str(k_max-k_min),525,220);
  text("Bundles per Kabadiwala: "+numBundlesPerKabadiwala,525,240);
  //quantities
  text("---Quantities From Each Household---", 525,260);
  text("Paper: "+ wt_paper + " KG",525,280);
  text("Plastic:  " + wt_plastic + " KG",525,300);
  text("Glass:  " + wt_glass + " KG",525,320);
  text("Metal: " + wt_metal + " KG",525,340);
  text("------------------------------------",525,360);
  text("Rates   |   HH to K   |   K to W   |   K to MRF ", 525,380);
  text("Plastic",525,400);
  text("Paper",525,420);
  text("Glass",525,440);
  text("Metal",525,460);
  //HH to K
  text(paperKBuy + " INR",585,400);
  text(plasticKBuy + " INR",585,420);
  text(glassKBuy + " INR",585,440);
  text(metalKBuy + " INR",585,460);
  //dividers
  text("|", 568,400);
  text("|", 568,420);
  text("|", 568,440);
  text("|", 568,460);
  text("|", 640,400);
  text("|", 640,420);
  text("|", 640,440);
  text("|", 640,460);
  text("|", 705,400);
  text("|", 705,420);
  text("|", 705,440);
  text("|", 705,460);

  //K to W
  text(paperKSell +" INR",650,400);
  text(plasticKSell +" INR",650,420);
  text(glassKSell +" INR",650,440);
  text(metalKSell +" INR",650,460);
  //selling prices
  //total cost of buying
  text("----Kabadiwala Total Cost of Buying---", 525,480);
  text("Paper: "+kabadiwala_pickup_cost_paper,525,500);
  text("Plastic: "+kabadiwala_pickup_cost_plastic,525,520);
  text("Glass: "+kabadiwala_pickup_cost_glass,525,540);
  text("Metal: "+kabadiwala_pickup_cost_metal,525,560);
  text("Miscellaneous Items: "+ misc + " INR",525,580);

  //draw output box
  stroke(105,105,105);
  fill(105,105,105); //, 0*baseAlpha);
  rect(920, 150, 300, 550, 10);
  //draw output title
  textSize(16);
  rect(920,150,300,50,10);
  fill(50, 205, 50);
  text("Outputs",1040,180);
  //draw output content
  fill(255,255,255);
  textSize(12);
  text("Kabadiwala's Gross Profit: "+ (kabadiwala_offload_cost_paper - totalKPickupCost)+ " INR",925,220);
  text("Kabadiwala's Total Distance: "+ roundtripKM + " KM", 925, 240);

  //text("Distance for Kabadiwala 1: "+graphArray.get(1), 925, 260);
  //text("Distance for Kabadiwala 2: "+graphArray.get(2), 925, 280);
  textSize(12);
  fill(255,255,255);
  text("Distance for Each Kabadiwala Displayed", 925,260);
  //draw the graph
  fill(k_fill);
  stroke(k_fill);
  
  //each individual distance on a graph
  int x_offset = 0; //offset for graphs
  for(int e = 0; e<k_max-k_min; e++){
    if(e>0){
      rect(925+x_offset,280,5,-5*(graphArray.get(e)-graphArray.get(e-1))); //changed from -1 to make it easier to see
      x_offset+=5;
    }
    else if(e==0){
      rect(925+x_offset,280,5,-5*(graphArray.get(e)));
      x_offset+=5;
    }
  }
  
  fill(255,255,255);
  text("Distance for Each Kabadiwala Displayed", 925,340);
  //draw the graph
  fill(k_fill);
  stroke(k_fill);
  int x_sum_offset = 0; //offset for graphs
  //sum of distances on a graph
  for(int e = 0; e<k_max-k_min; e++){
      rect(925+x_sum_offset,380,5,-1*(graphArray.get(e)));
      x_sum_offset+=5;
  }
  
  int ctrl = 400;
  fill(255,255,255);
  text("CONTROLS", 925, ctrl);
  text("a: Decrease Kabadiwala Numbers", 925, ctrl+20);
  text("s: Increase Kabadiwala Numbers", 925, ctrl+40);
  text("e: Toggle Agent Rendering", 925, ctrl+60);
  text("ENTER/RETURN: Reset Simulation", 925, ctrl+80);
  text("1-6: Display Activity for Weekdays ",925,ctrl+100);
  text("Monday through Saturday", 925, ctrl+120);
  text("-- ZOOM --", 925, ctrl+140);
  text("z: Zoom to Ward H-W", 925, ctrl+160);
  text("x: Zoom to Ward R-N", 925, ctrl+180);
  text("c: Zoom to Ward N", 925, ctrl+200);
  text("v: View All of Mumbai", 925, ctrl+220);
  text("-- ACTIVATE --", 925, ctrl+240);
  text("m: Activate MRFs", 925, ctrl+260);
  text("w: Activate Wholesalers", 925, ctrl+280);
  
  
  
  
  //text("Kabadiwala's Roundtrip Average: " + roundtripKM
  //text("---------Bundle Status----------------", 925,260);
  //text("bundle times collected: "+b.timesCollected,925,280);
  //text("bundle is picked up? "+b.pickedUp,925,300);
  //text("---------Wholesalers----------------", 925,320);
  
  text("current day: "+currentDay, 1100, 70);

  
}
