Table MumbaiOutline, MumbaiWardBoundary, PopBlocks, PopData, kData, mrfData,transportNodes,transportData;

void loadData(){
  MumbaiOutline = loadTable("data/mumbai_outline-nodes.csv", "header");
  MumbaiWardBoundary = loadTable("data/mumbai_wards-nodes.csv","header");
  PopBlocks = loadTable("data/mumbai_pop2011-nodes.csv", "header");
  PopData = loadTable("data/mumbai_pop2011-attributes.csv", "header");
  kData = loadTable("data/k_short.csv", "header");
  mrfData = loadTable("data/mrf_formatted.csv", "header");
  transportData = loadTable("data/mumbai_transport-western-nodes.csv","header");
  //transportData = loadTable("data/mumbai_transport-western-attributes.csv","header");
  //load streets
  
  println("Data loaded");
}

void parseData(){
  
  //1. parse the ward polygons
  ArrayList<PVector> coords = new ArrayList<PVector>();
  //get lat and lon from Ward Boundary CSV
  for(int i=0; i<MumbaiWardBoundary.getRowCount(); i++){
    float lat = float(MumbaiWardBoundary.getString(i,2));
    float lon = float(MumbaiWardBoundary.getString(i,1));
    //add them to new PVector
    coords.add(new PVector(lat, lon));
  }
  
  outline_wards = new Polygon(coords);
  outline_wards.cityOutline = false; 
  outline_wards.wardOutline = true;
  outline_wards.makeShape();
  
  //2. parse population polygons
  int previd = 0; 
  coords = new ArrayList<PVector>();
  for(int i = 0; i<PopBlocks.getRowCount(); i++){
    //get shapeid for joining
    int shapeid = int(PopBlocks.getString(i, 0));
    if(shapeid != previd){
      if(coords.size() > 0){
        Polygon poly = new Polygon(coords);
        poly.id = shapeid; 
        PopPolygons.add(poly);
      }
      //clear coords
      coords = new ArrayList<PVector>();
      //reset variable
      previd = shapeid;
    }
    if(shapeid == previd){
      float lat = float(PopBlocks.getString(i,2));
      float lon = float(PopBlocks.getString(i,1));
      coords.add(new PVector(lat,lon));
    }
  }
  
  //add attribute of the polygon
   for(int i = 0; i<PopPolygons.size(); i++){
    PopPolygons.get(i).score = PopData.getFloat(i, "TOT_HH"); //this is ONLY if the IDs are accurate
    PopPolygons.get(i).colorByScore();
    PopPolygons.get(i).makeShape();
  }
  
  
   //get lat and lon from Outline CSV
  ArrayList<PVector> outline_coords = new ArrayList<PVector>();

  for(int i=0; i<MumbaiOutline.getRowCount(); i++){
    float lat = float(MumbaiOutline.getString(i,2));
    float lon = float(MumbaiOutline.getString(i,1));
    //add them to new PVector
    outline_coords.add(new PVector(lat, lon));
  }
  
  outline_city= new Polygon(outline_coords);
  outline_city.cityOutline = true; 
  outline_city.makeShape();
  
  
  //parse CSV for k
  int previd_k = 0; 
  ArrayList<PVector> kcoords = new ArrayList<PVector>();
  float lat_k, lon_k;
      
  for(int i = 0; i<kData.getRowCount(); i++){
    
    lat_k = float(kData.getString(i,2));
    lon_k = float(kData.getString(i,3));
    
    int k_id = int(kData.getString(i,0));
      if(k_id != previd_k){
        if(kcoords.size() > 0){ //create constructor for kcoords
          Point_k k = new Point_k(lat_k,lon_k);
          k.typeK = true;
          k_array.add(k);
        }
        //clear coords
        kcoords = new ArrayList<PVector>();
        //reset variable
        previd_k = k_id;
      }
      if(k_id == previd_k){
        float lat_kmatch = float(kData.getString(i,2)); //west
        float lon_kmatch = float(kData.getString(i,3));
        kcoords.add(new PVector(lat_kmatch, lon_kmatch));
      }
  }
  
  //parse CSV for MRF
  int previd_mrf = 0; 
  ArrayList<PVector> mrfcoords = new ArrayList<PVector>();
  float lat_mrf, lon_mrf;
      
  for(int i = 0; i<mrfData.getRowCount(); i++){
    
    lat_mrf = float(mrfData.getString(i,3));
    lon_mrf = float(mrfData.getString(i,4));
    
    int mrf_id = int(mrfData.getString(i,0));
      if(mrf_id != previd_mrf){
        if(mrfcoords.size() > 0){ //create constructor for kcoords
          Point_k mrf = new Point_k(lat_mrf,lon_mrf);
          //mrf.typeK = false;
          mrf.typeMRF = true;
          mrf_array.add(mrf);
        }
        //clear coords
        mrfcoords = new ArrayList<PVector>();
        //reset variable
        previd_mrf = mrf_id;
      }
      if(mrf_id == previd_mrf){
        float lat_mrfmatch = float(mrfData.getString(i,3)); //west
        float lon_mrfmatch = float(mrfData.getString(i,4));
        mrfcoords.add(new PVector(lat_mrfmatch, lon_mrfmatch));
      }
  }
  
  //parse CSV for lines
  float previd_transport = 0; 
  ArrayList<PVector> transportcoords = new ArrayList<PVector>();
  float lat_transport, lon_transport;
      
  for(int i = 0; i<transportData.getRowCount(); i++){
    lat_transport = float(transportData.getString(i,1));
    lon_transport = float(transportData.getString(i,2));
    
    float transport_id = float(transportData.getString(i,0));
      if(transport_id != previd_transport){
        if(transportcoords.size() > 0){ //create constructor for kcoords
          Way transport = new Way(lat_transport,lon_transport);
          transport.typeWestern = true;
          transport_ways.add(transport);
        }
        //clear coords
        transportcoords = new ArrayList<PVector>();
        //reset variable
        previd_transport = transport_id;
      }
      if(transport_id == previd_transport){
        float lat_transportmatch = float(transportData.getString(i,1)); //west
        float lon_transportmatch = float(transportData.getString(i,2));
        transportcoords.add(new PVector(lat_transportmatch, lon_transportmatch));
      }
  }
  
  //
  println("Data Parsed");
}
