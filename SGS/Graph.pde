//Class by D. Guzowski
//Abstract class for all other graph classes

abstract class Graph 
{
  int size;
 // ArrayList<LineGraph> graphs = new ArrayList<LineGraph>();
  abstract void draw();
  int getGraphListSize(){return size;}
  String getValue(int i){return "";}
 // ArrayList<LineGraph> getGraphs(){return graphs;}
}
