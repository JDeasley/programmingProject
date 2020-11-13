//Class created by J. Deasley and modified by O. Gallagher & D. Guzowski
//Compares 2 companies' ajdusted close over time on a ComparisonGraph

class CompareScreen extends Screen
{
  String ticker1, ticker2;
  String date1, date2;
  ComparisonGraph comparisonGraph;

  DateWidget dw1, dw2;
  SearchBox sb1, sb2;

  CompareScreen(String ticker1, String ticker2)
  {
    screenColor = color(255, 100, 100);
    this.ticker1 = ticker1;
    this.ticker2 = ticker2;
    date1 = "2005";
    date2 = "2018";
    setInfo(ticker1, ticker2, "2005", "2018");

    widgets.add(new Button(0.075, 0.1, BUTTON_WIDTH*2, 0.08, "Home", EVENT_HOME));
    widgets.add(new Button(0.225, 0.1, BUTTON_WIDTH*2, 0.08, "Update", EVENT_RESET));
    
    sb1 = new SearchBox(0.425, 0.1, 0.15, 0.08, "Ticker 1", 5, EVENT_NULL, true);
    sb2 = new SearchBox(0.725, 0.1, 0.15, 0.08, "Ticker 2", 5, EVENT_NULL, true);
    widgets.add(sb1);
    widgets.add(sb2);
    
    dw1 = new DateWidget(0.79, 0.275, 0.1, 0.01, "", EVENT_NULL);
    dw2 = new DateWidget(0.79, 0.485, 0.1, 0.01, "", EVENT_NULL);
    widgets.add(dw1);
    widgets.add(dw2);
    
    widgets.add(new InfoButton(0.925, 0.9, 0.05, 0.05, "Plot the prices of two stocks over a period. Interact with the plot to see growth on a date.", EVENT_NULL));

    update();
  }

  //Draw screen background designs, actual graph and other info.
  void draw()
  {
    comparisonGraph.draw();
    for (Widget widget : widgets)
    {
      widget.draw();
    }
    
    //Display red or Green growth/decline figures
    pushStyle();
    
    fill(0);
    textSize((width+height)/85);
    textAlign(LEFT, BOTTOM);
    fill(!comparisonGraph.getValue(0).contains("-")? color(0, 230, 0) : color(255, 0, 0));
    text(comparisonGraph.getValue(0), 0.505*width, 0.125*height-5);
    fill(!comparisonGraph.getValue(1).contains("-")? color(0, 230, 0) : color(255, 0, 0));
    text(comparisonGraph.getValue(1), 0.805*width, 0.125*height-5);
    
    popStyle();
    
    //Display tickers on graph. Text colour = corresponding line colour
    pushStyle();

    textSize((width+height)/24);
    textAlign(LEFT);
    colorMode(HSB);
    fill(0, 255, 170, 50);
    textAlign(LEFT, BOTTOM);
    text(ticker1, 0.1*width, height*0.5);
    fill(127.5, 255, 170, 50);
    textAlign(LEFT, TOP);
    text(ticker2, 0.1*width, height*0.5);
    textSize((width+height)/125);
    
    pushStyle();
    
    stroke(51);
    strokeWeight(0.5);
    rectMode(CORNER);
    fill(255, 200);
    rect(width*0.77, height*0.655, 0.22*width, (width + height)/15, 15);
    
    popStyle();
    
    //Display each company's growth over the day corresponding to mouse position on the graph
    String[] temp = comparisonGraph.getValue().split("\n");
    if (temp.length > 0)
    {
      String info = "";
      for(int i = 0; i < temp.length; i++)
      {
        info += (temp.length > 1? temp[i] : "");
        if(i != temp.length-1 && info.length() > 1)
        {
          info += "\n";
        }
      }
      info = comparisonGraph.getValue();
      fill(0);
      textAlign(LEFT, CENTER);
      textSize((width + height)/70);
      text(info, width*0.79, height*0.655 + (width + height)/23);
    }
    
    popStyle();
    
  }

  //Update graph info.
  void update() 
  {
    isLoading = true;
    Table[] tables = new Table[2];
    tables[0] = dataManager.linePlot(ticker1, date1, date2);
    tables[1] = dataManager.linePlot(ticker2, date1, date2);
    String name1 = dataManager.stockInfo(ticker1, 3), name2 = dataManager.stockInfo(ticker2, 3);
    name1 = name1.length() > 30? name1.substring(0, 29) + "..." : name1;
    name2 = name2.length() > 30? name2.substring(0, 29) + "..." : name2;
    String title = String.format("%s vs %s", name1, name2);
    comparisonGraph = new ComparisonGraph(tables, title.replace("&#39;", "'"), 0.05, 0.25, 0.7, 0.6);
    isLoading = false;
  }

  //Initialise data for first graph
  void setInfo(String ticker1, String ticker2, String date1, String date2) 
  {
    this.ticker1 = ticker1.equals("")?this.ticker1:ticker1;
    this.ticker2 = ticker2.equals("")?this.ticker2:ticker2;
    this.date1 = Date.toDays(date1)>Date.toDays(date2)?date2:date1;
    this.date2 = Date.toDays(date1)>Date.toDays(date2)?date1:date2;
    if (date1.equals(date2)) {
      this.date1 = "1970";
      this.date2 = "2018";
    }
  }

  @Override
  int getEvent(MouseEvent e)
  {
    for (Widget widget : widgets) 
    {
      int event = widget.getEvent(e);

      if (event == EVENT_RESET) 
      {
        setInfo(sb1.getLabel(), sb2.getLabel(), dw1.getDate(), dw2.getDate());
        thread("updateComparison");
      } else if (event > EVENT_NULL) 
      {
        return event;
      }
    }
    return EVENT_NULL;
  }

  @Override
  int getEvent(KeyEvent e)
  {
    for (Widget widget : widgets)
    {
      widget.getEvent(e);
    }
    if (!sb1.isFocused() && !sb2.isFocused() && key == BACKSPACE)
    {
      return EVENT_HOME;
    }
    if (keyCode == ENTER || keyCode == RETURN)
    {
      setInfo(sb1.getLabel(), sb2.getLabel(), dw1.getDate(), dw2.getDate());
      thread("updateComparison");
    }
    return EVENT_NULL;
  }
}
