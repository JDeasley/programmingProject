//Class made by J. Deasley, modified by D. Guzowski
//Displays all stocks as a spreadsheet in which the user can search for names

class StocksScreen extends Screen
{
  Spreadsheet spreadsheet;
  SearchBox searchbox;
  
  StocksScreen(Spreadsheet spreadsheet)
  {
    this.spreadsheet=spreadsheet;
    searchbox = new SearchBox(0.475, 0.075, 0.5, 0.075, "Search Ticker", 20, EVENT_NULL, false);
    screenColor = color(0,200,0);
    
    widgets.add(new Button(MARGIN+BUTTON_WIDTH, 0.075, 2*BUTTON_WIDTH, 1.5*BUTTON_HEIGHT, "Home", EVENT_HOME));
    widgets.add(new Button(0.725+1.2*MARGIN, 0.075, 2*BUTTON_WIDTH, 1.5*BUTTON_HEIGHT, "Reset", EVENT_RESET));
    widgets.add(new InfoButton(0.925, 0.075, 0.05, 0.05, "Stocks in the dataset. Click entries to create profiles.", EVENT_NULL));
  }
  
  void draw()
  {
    spreadsheet.draw();
    searchbox.draw();
    for(Widget widget: widgets)
    {
      widget.draw();
    }
    pushStyle();
    textAlign(LEFT, BOTTOM);
    textSize((width + height)/125);
    popStyle();
  }
  
  @Override
  int getEvent(KeyEvent e)
  {
    for(Widget widget: widgets)
    {
     int event = widget.getEvent(e);
     if(event > EVENT_NULL) return event;
    }
    if(searchbox.getEvent(e) > EVENT_NULL)
    {
      thread("updateStocks");
    }
    switch(e.getAction())
    {
    case KeyEvent.PRESS:
      switch(key)
      {
        case BACKSPACE:
          if(!searchbox.isFocused())
            return EVENT_HOME;
      }
    }
    return EVENT_NULL;
  }
  
  @Override
  int getEvent(MouseEvent e)
  {
    spreadsheet.getEvent(e);
    int event = searchbox.getEvent(e);
    if(event > EVENT_NULL) return event;
    for(Widget widget:widgets)
    {
      event = widget.getEvent(e);
      if(event == EVENT_RESET) thread("resetStocks");
      if(event > EVENT_NULL) return event;
    }
    return EVENT_NULL;
  }
}
