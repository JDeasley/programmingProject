//Class created by D. Guzowski.
//Creates a histogram-like graph of growths given in a table. 
class GrowthGraph extends Graph
{
  float maxY, minY, intervalX, intervalY;
  float graphX, graphY, graphWidth, graphHeight;
  int intervalLines = 10;
  Table dataTable;
  boolean emptyTable = false;
  float barWidth;

  GrowthGraph(Table tab, float x, float y, float w, float h)
  {
    graphX = x;
    graphY = y;
    graphWidth = w;
    graphHeight = h;
    dataTable = tab;
    setScale();
  }

  //Adjusts the scale of the graph given the data from the table.
  void setScale()
  {
    if (dataTable.getRowCount() == 0)
    {
      emptyTable = true;
    }
    
    if (!emptyTable)
    {
      maxY = 0;
      for (int i = 0; i < dataTable.getRowCount(); i++)
      {
        TableRow info = dataTable.getRow(i);
        if (maxY < abs(float(info.getString(0))))
        {
          maxY = abs(float(info.getString(0)));
        }
      }

      maxY += maxY/10;
      minY = -maxY;

      if (dataTable.getRowCount() > 10)
      {
        barWidth = (graphWidth*width)/dataTable.getRowCount();
      } else
      {
        barWidth = (graphWidth*width)/10;
      }
    }
  }

  //Draws graph to the screen and allows user interaction.
  void draw()
  {
    if (!emptyTable)
    {
      pushStyle();
      drawGrid();
      rectMode(CORNERS);
      for (int i = 0; i < dataTable.getRowCount(); i++)
      {
        TableRow row = dataTable.getRow(i);
        if (row != null)
        {
          float x = map(i, 0, dataTable.getRowCount(), graphX*width, graphX*width + graphWidth*width) + ((dataTable.getRowCount() <= 10)? ((graphWidth*width-dataTable.getRowCount()*barWidth)/((dataTable.getRowCount())))/2 : 0);
          float y = graphY*height + graphHeight*height/2;
          float h = map(float(row.getString(0)), 0, maxY, graphY*height + graphHeight*height/2, graphY*height);
          fill((float(row.getString(0)) >= 0)?  color(0, 220, 0) : color(255, 0, 0));
          rect(x, y, x+barWidth, h, ((float(row.getString(0)) > 0)? 5 : 0), ((float(row.getString(0)) > 0)? 5 : 0), ((float(row.getString(0)) > 0)? 0 : 5), ((float(row.getString(0)) > 0)? 0 : 5));
        }
      }
      if (dataTable.getRowCount() > 10)
      {
        barWidth = (graphWidth*width)/dataTable.getRowCount();
      } else
      {
        barWidth = (graphWidth*width)/10;
      }
      popStyle();
    } else
    {
      pushStyle();
      rectMode(CORNERS);
      fill(255);
      rect(graphX*width, graphY*height, graphX*width + graphWidth*width, graphY*height + graphHeight*height, 10, 10, 10, 10);
      textAlign(CENTER, CENTER);
      textSize(sqrt(width*width + height*height)/16);
      fill(0);
      text("NO DATA", graphX*width + graphWidth*width/2, graphY*height + graphHeight*height/2);
      popStyle();
    }
  }

  //Draws the grid for the graph.
  void drawGrid()
  {
    pushStyle();
    colorMode(RGB);
    fill(255, 150);
    stroke(51);
    rectMode(CORNERS);
    rect(graphX*width, graphY*height, graphX*width + graphWidth*width, graphY*height + graphHeight*height, 10, 10, 10, 10);
    fill(0);
    textAlign(RIGHT, CENTER);
    textSize((width + height)/150);
    for (int i = 0; i < 5; i++)
    {
      text(((map(i, 0, 4, minY, maxY) > 0)? "+" : "" ) + String.format("%.3f", map(i, 0, 4, minY, maxY)) + "% ", graphX*width, map(i, 0, 4, graphY*height + graphHeight*height, graphY*height));
    }
    stroke(0);
    line(graphX*width, graphY*height + graphHeight*height/2, graphX*width + graphWidth*width, graphY*height+ graphHeight*height/2);
    popStyle();
  }

  //Returns a formatted string of values given in the table with 4 columns, to be called outside the class, after the draw function.
  String getValue()
  {
    for (int i = 0; i < dataTable.getRowCount(); i++)
    {
      TableRow row = dataTable.getRow(i);
      if (row != null)
      {
        float x = map(i, 0, dataTable.getRowCount(), graphX*width, graphX*width + graphWidth*width) + ((dataTable.getRowCount() <= 10)? ((graphWidth*width-dataTable.getRowCount()*barWidth)/((dataTable.getRowCount())))/2 : 0);
        float y = graphY*height + graphHeight*height/2;
        float h = map(float(row.getString(0)), 0, maxY, graphY*height + graphHeight*height/2, graphY*height) - y;
        if (mouseX > x && mouseX < x+barWidth && mouseY > graphY*height && mouseY < graphY*height+graphHeight*height)
        {
          pushStyle();
          rectMode(CORNER);
          fill((float(row.getString(0)) >= 0)?  color(75, 255, 0) : color(255, 75, 0));
          rect(x, y, barWidth, h, ((float(row.getString(0)) > 0)? 5 : 0), ((float(row.getString(0)) > 0)? 5 : 0), ((float(row.getString(0)) > 0)? 0 : 5), ((float(row.getString(0)) > 0)? 0 : 5));
          popStyle();
          return String.format("%s%n%s%n%s%n%s: %s%s%s", row.getString(2).length() < 30 ? row.getString(2) : row.getString(2).substring(0, 25) + "...", row.getString(1), row.getString(3).length() < 30 ? row.getString(3) : row.getString(3).substring(0, 25) + "...", "Growth", (float(row.getString(0)) > 0)? "+" : "", String.format("%.5f", float(row.getString(0))), "%");
        }
      }
    }
    return "";
  }
}
