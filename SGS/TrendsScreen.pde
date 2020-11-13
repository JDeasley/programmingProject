//Class created by D. Guzowski
//Shows a screen where a user may interact with widgets and the graph, and also update the graph to display different results by changing the date.

class TrendsScreen extends Screen
{
  ArrayList<Widget> widgets;
  GrowthGraph trendsGraph;
  DateWidget dateWidget;
  String date;
  String graphTitle;

  TrendsScreen()
  {
    date = "1999-06-23";
    widgets = new ArrayList<Widget>();
    dateWidget = new DateWidget(0.0305, 0.35, 0.1, 0.01, "", EVENT_NULL);
    
    widgets.add(dateWidget);
    widgets.add(new Button(0.305, 0.415, BUTTON_WIDTH*2, 0.08, "Update", EVENT_DATE));
    widgets.add(new Button(0.075, 0.1, BUTTON_WIDTH*2, 0.08, "Home", EVENT_HOME));
    trendsGraph = new GrowthGraph(dataManager.growthGraph(date), 0.45, 0.35, 0.5, 0.6);
    widgets.add(new InfoButton(0.1, 0.9, 0.05, 0.05, "Trending companies on a date. Trends are changes in price.", EVENT_NULL));
    
    int tempDays = Date.toDays(date);
    Date.setDateFormat(Date.STANDARD);
    Date.setDateDividerSymbol("/");
    graphTitle = "Growth Trends on " + Date.toDate(tempDays);
    Date.setDefault();
  }

  //Draws the trends screen onto the main screen.
  void draw()
  {
    pushStyle();
    fill(51, 50);
    textSize((width+height)/12);
    textAlign(RIGHT, TOP);
    text(date, width, 0);
    trendsGraph.draw();
    String graphInfo = trendsGraph.getValue();
    fill(0);
    textSize(sqrt(width*width+height*height)/35);
    textAlign(CENTER, BOTTOM);
    text(graphTitle, 0.7*width, 0.35*height);
    pushStyle();
    stroke(51);
    strokeWeight(0.5);
    rectMode(CORNER);
    fill(255, 200);
    rect(width*0.0115, height*0.55, (width + height)/4.25, (width + height)/10, 15);
    popStyle();
    if (graphInfo.length() > 0) 
    {
      textSize((width+height)/80);
      fill(0);
      textAlign(LEFT, TOP);
      text(graphInfo, width*0.0225, height*0.55 + (width+height)/80);
    }
    for (Widget widget : widgets)
    {
      widget.draw();
    }
    popStyle();
  }

  //updates the date from the date widget and updates the trends graph.
  void setDate(String newDate)
  {
    date = newDate;
    int tempDays = Date.toDays(date);
    Date.setDateFormat(Date.STANDARD);
    Date.setDateDividerSymbol("/");
    graphTitle = "Growth Trends on " + Date.toDate(tempDays);
    Date.setDefault();
    thread("updateTrends");
  }

  @Override
    // Key events for updating and returning home
    int getEvent(KeyEvent e)
  {
    switch(e.getAction())
    {
    case KeyEvent.PRESS:
      switch(key)
      {
      case BACKSPACE:
        return EVENT_HOME;
      case ENTER:
        setDate(dateWidget.getDate());
        break;
      }
    }
    return EVENT_NULL;
  }

  @Override
    //Returns the event value from a widget.
    int getEvent(MouseEvent e) 
  {
    for (Widget widget : widgets) 
    {
      int event = widget.getEvent(e);
      if (event == EVENT_DATE)
      {
        setDate(dateWidget.getDate());
      } else if (event > EVENT_NULL) 
      {
        return event;
      }
    }
    return EVENT_NULL;
  }
}
