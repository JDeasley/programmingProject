//Class made by J. Deasley & modified by D. Guzowski
//Shows a single company's performance over time, using all data for each company

class Profile extends Screen
{
  String ticker, name, industry, exchange, sector;
  int graphIndex;
  PFont Font1;
  
  //Displays a simple profile for each company searched, enabling you to switch between different companies for comparison
  Profile(DataManager dataManager, String ticker)
  {
    screenColor = color(100,150,255);
    this.ticker=ticker;
    this.name=dataManager.stockInfo(ticker, 3);
    this.industry=dataManager.stockInfo(ticker, 0);
    this.exchange=dataManager.stockInfo(ticker, 2);
    this.sector=dataManager.stockInfo(ticker, 1);
    graphIndex=0;
    Font1 = createFont("Arial Bold", 18);
    
    //Table for use in making timeframe graphs
    Table maxTable = dataManager.profile(ticker);
    Table fiveYrTable = dataManager.profile(ticker, 5);
    Table oneYrTable = dataManager.profile(ticker, 4);
    Table sixMthTable = dataManager.profile(ticker, 3);
    Table threeMthTable = dataManager.profile(ticker, 2); 
    Table oneMthTable = dataManager.profile(ticker, 1);
    Table oneWkTable = dataManager.profile(ticker, 0);
    
    //All timeframe graphs preloaded
    graphs.add(new ProfileGraph(maxTable, "Adjusted Close - All Time", GRAPH_X, GRAPH_Y, GRAPH_WIDTH, GRAPH_HEIGHT));
    graphs.add(new ProfileGraph(oneWkTable, "Adjusted Close - 1 Week", GRAPH_X, GRAPH_Y, GRAPH_WIDTH, GRAPH_HEIGHT));
    graphs.add(new ProfileGraph(oneMthTable, "Adjusted Close - 1 Month", GRAPH_X, GRAPH_Y, GRAPH_WIDTH, GRAPH_HEIGHT));
    graphs.add(new ProfileGraph(threeMthTable, "Adjusted Close - 3 Months", GRAPH_X, GRAPH_Y, GRAPH_WIDTH, GRAPH_HEIGHT));
    graphs.add(new ProfileGraph(sixMthTable, "Adjusted Close - 6 Months", GRAPH_X, GRAPH_Y, GRAPH_WIDTH, GRAPH_HEIGHT));
    graphs.add(new ProfileGraph(oneYrTable, "Adjusted Close - 1 Year", GRAPH_X, GRAPH_Y, GRAPH_WIDTH, GRAPH_HEIGHT));
    graphs.add(new ProfileGraph(fiveYrTable, "Adjusted Close - 5 Years", GRAPH_X, GRAPH_Y, GRAPH_WIDTH, GRAPH_HEIGHT));
    
    //Buttons for navigating between profiles, removing profiles, and going back to the home screen
    widgets.add(new Button(MARGIN, PROFILE_NAV_Y, BUTTON_WIDTH, BUTTON_HEIGHT, "Home", EVENT_HOME));
    widgets.add(new Button(MARGIN+NEXT_BUTTON, PROFILE_NAV_Y, BUTTON_WIDTH, BUTTON_HEIGHT, "Delete", EVENT_DELETE));
    widgets.add(new Button(MARGIN+2*NEXT_BUTTON, PROFILE_NAV_Y, BUTTON_WIDTH, BUTTON_HEIGHT, "◄", EVENT_PREVIOUS));
    widgets.add(new Button(MARGIN+3*NEXT_BUTTON, PROFILE_NAV_Y, BUTTON_WIDTH, BUTTON_HEIGHT, "►", EVENT_NEXT));
    
    //Buttons for indexing through an arraylist of ProfileGraphs, filtered by date, which are preloaded with the profile
    widgets.add(new Button(MARGIN, PROFILE_TF_Y, BUTTON_WIDTH, BUTTON_HEIGHT, "1W", EVENT_1WEEK));
    widgets.add(new Button(MARGIN+NEXT_BUTTON, PROFILE_TF_Y, BUTTON_WIDTH, BUTTON_HEIGHT, "1M", EVENT_1MONTH));
    widgets.add(new Button(MARGIN+2*NEXT_BUTTON, PROFILE_TF_Y, BUTTON_WIDTH, BUTTON_HEIGHT, "3M", EVENT_3MONTHS));
    widgets.add(new Button(MARGIN+3*NEXT_BUTTON, PROFILE_TF_Y, BUTTON_WIDTH, BUTTON_HEIGHT, "6M", EVENT_6MONTHS));
    widgets.add(new Button(MARGIN+4*NEXT_BUTTON, PROFILE_TF_Y, BUTTON_WIDTH, BUTTON_HEIGHT, "1Y", EVENT_1YEAR));
    widgets.add(new Button(MARGIN+5*NEXT_BUTTON, PROFILE_TF_Y, BUTTON_WIDTH, BUTTON_HEIGHT, "5Y", EVENT_5YEARS));
    widgets.add(new Button(MARGIN+6*NEXT_BUTTON, PROFILE_TF_Y, BUTTON_WIDTH, BUTTON_HEIGHT, "MAX", EVENT_MAX));
    
    widgets.add(new InfoButton(0.85, 0.9, 0.05, 0.05, "Interact with the graph to observe statistics for a stock.", EVENT_NULL));
  }
  
  void draw()
  {
    pushStyle();
    fill(200, 100);
    textSize((width+height)/6);
    textAlign(RIGHT, TOP);
    text(ticker, width, -(width+height)/50);
    popStyle();
    pushStyle();
    fill(0);
    textSize((width+height)/60);
    text(name.replace("&#39;", "'"), width*0.05, height*0.1);
    textSize((width+height)/100);
    text(industry, width*0.05, height*0.15);
    text(exchange + " - " + sector.replace("&#39;", "'"), width*0.05, height*0.20);
    popStyle();
    
    graphs.get(graphIndex).draw();
    for(Widget widget:widgets)
    {
      widget.draw();
    }
    
    //Displays all company data on the day highlighted in the graph
    pushStyle();
    fill(0);
    pushStyle();
    textFont(Font1);
    textSize((width + height)/80);
    text(graphs.get(graphIndex).getValue(1), width*DATA_X, height*DATA_Y);
    popStyle();
    textSize((width+height)/100);
    text("Date: " + graphs.get(graphIndex).getValue(0), width*DATA_X, height*(DATA_Y+NEXT_LINE));
    text("Open: " + graphs.get(graphIndex).getValue(2), width*DATA_X, height*(DATA_Y+2*NEXT_LINE));
    text("High: " + graphs.get(graphIndex).getValue(3), width*DATA_X, height*(DATA_Y+3*NEXT_LINE));
    text("Low: " + graphs.get(graphIndex).getValue(4), width*DATA_X, height*(DATA_Y+4*NEXT_LINE));
    text("Close: " + graphs.get(graphIndex).getValue(5), width*DATA_X, height*(DATA_Y+5*NEXT_LINE));
    text("Volume: " + graphs.get(graphIndex).getValue(6), width*DATA_X, height*(DATA_Y+6*NEXT_LINE));
    popStyle();
    
  }
  
  @Override
  int getEvent(MouseEvent e)
  {
    for(Widget widget:widgets)
    {
      int event = widget.getEvent(e);
      switch(event)
      {
        case EVENT_1WEEK:
          graphIndex = 1;
          break;
        case EVENT_1MONTH:
          graphIndex = 2;
          break;
        case EVENT_3MONTHS:
          graphIndex = 3;
          break;
        case EVENT_6MONTHS:
          graphIndex = 4;
          break;
        case EVENT_1YEAR:
          graphIndex = 5;
          break;
        case EVENT_5YEARS:
          graphIndex = 6;
          break;
        case EVENT_MAX:
          graphIndex = 0;
          break;
      }
      if(event > EVENT_NULL) 
      {
        return event;
      }
    }
    return EVENT_NULL;
  }
  
  @Override
  int getEvent(KeyEvent e)
  {
    for(Widget widget:widgets)
    {
      int event = widget.getEvent(e);
      if(event > EVENT_NULL)
      {
        return event;
      }
    }
    switch(e.getAction())
    {
    case KeyEvent.PRESS:
      switch(key)
      {
        case BACKSPACE:
          return EVENT_HOME;
      }
    }
    return EVENT_NULL;
  }
  
  
  String getTicker()
  {
    return ticker;
  }
}
