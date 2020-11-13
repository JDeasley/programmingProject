//Class made by J. Deasley, modified by D. Guzowski
//Home screen, routes to and from all other screens

class Home extends Screen
{
  Home() 
  {
    widgets.add(new SearchBox(0.5, 0.65, HOME_BUTTON_WIDTH, HOME_BUTTON_HEIGHT, "Search Ticker", 5, EVENT_NULL, true));
    widgets.add(new Button(0.5, 0.85, HOME_BUTTON_WIDTH, HOME_BUTTON_HEIGHT, "Profiles", EVENT_PROFILES));
    widgets.add(new Button(0.25, 0.65, HOME_BUTTON_WIDTH, HOME_BUTTON_HEIGHT, "Compare", EVENT_COMPARE));
    widgets.add(new Button(0.75, 0.65, HOME_BUTTON_WIDTH, HOME_BUTTON_HEIGHT, "Trades", EVENT_TRADES));
    widgets.add(new Button(0.25, 0.85, HOME_BUTTON_WIDTH, HOME_BUTTON_HEIGHT, "Stocks", EVENT_STOCKS));
    widgets.add(new Button(0.75, 0.85, HOME_BUTTON_WIDTH, HOME_BUTTON_HEIGHT, "Trends", EVENT_TRENDS));
  }

  void draw() 
  {
    for (Widget widget : widgets)
    {
      widget.draw();
    }
    pushStyle();
    textSize(width/16);
    textAlign(CENTER, CENTER);
    fill(0);
    rectMode(CENTER);
    popStyle();
    logo(0.5, 0.35, (width*height)/( height+width)/8);
  }
}
