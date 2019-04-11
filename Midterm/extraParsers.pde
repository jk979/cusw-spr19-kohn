void parseDataMumbai() {
  //loop through each of the feature sets in Mumbai
  for (int f=0; f<geometries.size(); f++) {
    //println("a geometry"+i); //each geometries is a JSONArray, there are 17
    featureCollection = geometries.getJSONObject(f);
    features = featureCollection.getJSONArray("features");
    for (int g = 0; g<features.size(); g++) {
      String type = features.getJSONObject(g).getJSONObject("geometry").getString("type");
      JSONObject geometry = features.getJSONObject(g).getJSONObject("geometry");
      JSONObject properties = features.getJSONObject(g).getJSONObject("properties");

      //query the polygons
      String dataFclass = properties.getString("fclass");
      String fclass = "";
      if (dataFclass!=null) fclass = dataFclass;
      else fclass = "";

      //make Ways if way
      if (type.equals("MultiLineString")) {
        ArrayList<PVector> coords = new ArrayList<PVector>();
        //get coordinates and iterate
        JSONArray coordinates = geometry.getJSONArray("coordinates").getJSONArray(0);
        for (int j = 0; j < coordinates.size(); j++) {
          float lat = coordinates.getJSONArray(j).getFloat(1);
          float lon = coordinates.getJSONArray(j).getFloat(0);
          //make PVector and add it
          PVector coordinate = new PVector(lat, lon);
          coords.add(coordinate);
        }
        //create Way with coordinate PVectors
        Way way = new Way(coords);

        if (fclass.equals("motorway") || fclass.equals("trunk") || fclass.equals("secondary") || fclass.equals("residential") || fclass.equals("tertiary") || fclass.equals("motorway_link")) {
          way.Street = true;
        }
        if (fclass.equals("coastline")) {
          way.Coastline = true;
        }
        if (fclass.equals("rail")) {
          way.Rail = true;
        }
        if (fclass.equals("river")) {
          way.Waterway = true;
        }


        ways.add(way);

        //make pair-nodes to draw a random point on any segment in the list of segments
        if (way.Street == true) {
          //coordinates.size() is the size of each road array
          //firstElement and secondElement are the base road elements--the first and second lat-long coordinate pairs in a node: [] and []
          //singlePair is a pair of joined road nodes: [ [],[] ]
          //collectionOfPairs will be a collection of pairs of road nodes: [ [ [],[] ], [ [],[] ] ]
          //concatenate collectionOfPairs for all streets you loop through
          PVector firstElement = new PVector();
          PVector secondElement = new PVector();

          //for each element in the single road array:
          for (int a = 0; a < coords.size()-1; a++) {
            ArrayList singlePair = new ArrayList<PVector>();
            firstElement = coords.get(a);
            secondElement = coords.get(a+1);
            //add 1 and 2 to singlePair
            singlePair.add(firstElement);
            singlePair.add(secondElement);
            //add singlePair to the collection for that road
            collectionOfPairs.add(singlePair);
            collectionOfCollections.add(singlePair);
          } //end make singlePairs
        } //end if way Street == true
      }//end if type = MultiLineString

      //make Polygons if polygon
      if (type.equals("MultiPolygon")) {
        ArrayList<PVector> coords = new ArrayList<PVector>();
        //get coordinates and iterate through them
        JSONArray coordinates = geometry.getJSONArray("coordinates").getJSONArray(0).getJSONArray(0);
        for (int j = 0; j < coordinates.size(); j++) {
          float lat = coordinates.getJSONArray(j).getFloat(1);
          float lon = coordinates.getJSONArray(j).getFloat(0);
          //make PVector and add it
          PVector coordinate = new PVector(lat, lon);
          coords.add(coordinate);
        }
        //create Polygon with coordinate PVectors
        Polygon poly = new Polygon(coords);

        if (fclass.equals("building")) {
          //println("found a building");
          poly.BuildingResidential = true;
          poly.makeShape();
        }
        polygons.add(poly);
      } //end if type = MultiPolygon
    } //end iterating through Features

    //parse Kabadiwala and MRF points
    parseKabadiwala();
    parseMRF();
  } //end iterate through Feature Sets
} //end ParseDataMumbai

void parseOSMNX() {
  //parse the JSON object
  JSONObject feature = features.getJSONObject(0);
  println("feature loaded");
  //get the lines within this road file
  for (int i = 0; i<features.size(); i++) {
    String type = features.getJSONObject(i).getJSONObject("geometry").getString("type");
    println("type: ", type);
    JSONObject geometry = features.getJSONObject(i).getJSONObject("geometry");
    println("geometry: ", geometry);
    JSONObject properties = features.getJSONObject(i).getJSONObject("properties");
    println("properties: ", properties);

    //add just the simplified road network of Ways
    //street lines
    String dataStreet;
    try {
      dataStreet = properties.getString("highway");
    }
    catch (Exception e) {
      dataStreet = properties.getJSONArray("highway").getString(0); //if it's an array, just get the first one
    }
    String street = "";
    if (dataStreet!=null) street = dataStreet;
    else street = "";

    parseMRF();
    parseKabadiwala();

    //make Way if LineString
    if (type.equals("MultiLineString")) {
      ArrayList<PVector> coords = new ArrayList<PVector>();
      //get coordinates and iterate through them
      JSONArray coordinates = geometry.getJSONArray("coordinates");
      println("coordinates are: ", coordinates);
      for (int j = 0; j<coordinates.size(); j++) {
        for (int c = 0; c<2; c++) {
          float lat = coordinates.getJSONArray(j).getJSONArray(c).getFloat(1); //need to fix and convert these to decimal
          float lon = coordinates.getJSONArray(j).getJSONArray(c).getFloat(0);
          //make PVector and add it
          PVector coordinate = new PVector(lat, lon);
          coords.add(coordinate);
        }
      }
      //create Way with coordinate PVectors
      Way way = new Way(coords);

      if (street.equals("unclassified") || street.equals("motorway") || street.equals("trunk") || street.equals("primary") || street.equals("secondary") || street.equals("residential") || street.equals("tertiary") || street.equals("motorway_link")) {
        way.Street = true;
      }

      ways.add(way);

      //make pair-nodes
      if (way.Street == true) {
        PVector firstElement = new PVector();
        PVector secondElement = new PVector();

        for (int a = 0; a < coords.size()-1; a++) {
          ArrayList singlePair = new ArrayList<PVector>();
          firstElement = coords.get(a);
          secondElement = coords.get(a+1);
          singlePair.add(firstElement);
          singlePair.add(secondElement);
          collectionOfPairs.add(singlePair);
          collectionOfCollections.add(singlePair);
        } //end make singlePairs
      } //end if way Street == true
    } //end if type equals MultiLineString
  } //end iterating through Features

  //checking to see if this is correct structure
  println("Total segment pairs in this road file: "+collectionOfCollections.size());
} //end parseOSMNX function
