//Main - Implements all other classes and handles most events
//Managed by O. Gallagher

DataManager dataManager;
ArrayList<Profile> profiles;
ArrayList<Screen> screens;

int state;
int profileIndex;
String query;

PieScreen pieScreen;
CompareScreen compareScreen;
StocksScreen stocksScreen;
TrendsScreen trendsScreen;
Spreadsheet spreadsheet;

void settings()
{
  size(1000, 600);
}

//Initialise profiles and screen arrayLists, as well as general setup
void setup()
{
  isLoading = true;
  profiles = new ArrayList<Profile>();
  screens = new ArrayList<Screen>();
  smooth();
  surface.setTitle("GoogolStox");
  surface.setResizable(true);
  thread("loadSetup");
}

//Draws a screen depending on state: 0 = Home, 1 = Profile, 2 = Trades, 3 = Stocks, 4 = Compare, 5 = Trends
void draw()
{
  if (isLoading) 
  {
    loading();
  } else if (screens.get(state) == null) 
  {
    switch(state) 
    {
    case 0: 
      screens.set(state, new Home());
      break;
    case 1:
      screens.set(1, profiles.get(profileIndex));
      break;
    case 2: 
      thread("pieCreate");
      break;
    case 3:
      thread("stocksCreate");
      break;
    case 4: 
      thread("compareCreate");
      break;
    case 5:
      thread("trendsCreate");
      break;
    }
  } else 
  {
    if (state == 1 && profiles.size() > 0) screens.set(1, profiles.get(profileIndex));
    background(255);
    drawGradient(0, height/3, width, height, color(255), color(100, 150, 255), 1);
    screens.get(state).draw();
  }
}

//mouseMoved used to call getEvent methods, used primarily to highlight buttons when you hover over them with the mouse
void mouseMoved(MouseEvent e) 
{
  if (!isLoading)
  {
    if (screens.get(state) != null && !isLoading)
    {
      screens.get(state).getEvent(e);
    }
  }
}

//keyPressed method used for navigating menus using the keyboard, as an alternative to using buttons
void keyPressed(KeyEvent e) 
{
  if(!isLoading)
  {
    switch(screens.get(state).getEvent(e))
    {
    case EVENT_HOME:
      state = 0;
      break;
    case EVENT_ENTER:
      {
        if (state == 0)
        {
          boolean alreadyMade = false;
          for (Profile profile : profiles) 
          {
            if (query.equals(profile.getTicker())) 
            {
              alreadyMade = true;
              profileIndex = profiles.indexOf(profile);
              state = 1;
            }
          }
          if (!alreadyMade) 
          {
            thread("profileCreate");
          }
        }
      }
    }
    if (state == 1)
    {
      if (key == CODED) 
      {
        switch(keyCode) 
        {
        case LEFT: 
          profileIndex = profileIndex > 0? profileIndex-1 : profiles.size()-1;
          break;
        case RIGHT: 
          profileIndex = profileIndex < profiles.size()-1? profileIndex+1 : 0;
          break;
        }
      }
    }
  }
}

//mouseReleased used for widget events to navigate menus
void mouseReleased(MouseEvent e) 
{
  if (!isLoading)
  {
    if (state != 1) 
    {
      switch(screens.get(state).getEvent(e))
      {
      case EVENT_HOME:
        state = 0;
        if (screens.get(state) != null)
        {
          thread("stateChange");
        }
        break;
      case EVENT_TRADES:
        state = 2;
        if (screens.get(state) != null)
        {
          thread("stateChange");
        }
        break;
      case EVENT_PROFILES:
        if (profiles.size()<1) 
        {
          query = "FLWS";
          thread("profileCreate");
        }
        state = 1;
        if (screens.get(state) != null)
        {
          thread("stateChange");
        }
        break;
      case EVENT_STOCKS:
        state = 3;
        if (screens.get(state) != null)
        {
          thread("stateChange");
        }
        break;
      case EVENT_COMPARE:
        state = 4;
        if (screens.get(state) != null)
        {
          thread("stateChange");
        }
        break;
      case EVENT_TRENDS:
        state = 5;
        if (screens.get(state) != null)
        {
          thread("stateChange");
        }
        break;
      default:
        break;
      }
    } 
    else 
    {
      switch(profiles.get(profileIndex).getEvent(e))
      {
      case EVENT_HOME:
        state = 0;
        if (screens.get(state) != null)
        {
          thread("stateChange");
        }
        break;
      case EVENT_PREVIOUS:
        profileIndex = profileIndex > 0? profileIndex-1 : profiles.size()-1;
        break;
      case EVENT_NEXT:
        profileIndex = profileIndex < profiles.size()-1? profileIndex+1 : 0;
        break;
      case EVENT_DELETE:
        if (profiles.size() <= 1) 
        {
          state = 0;
          profiles.remove(0);
        } 
        else 
        {
          profiles.remove(profileIndex);
          if (profiles.size() <= profileIndex)
          {
            profileIndex=profiles.size()-1;
          }
        }
        break;
      }
    }
  }
}

//Used primarily for sliders in dateWidget
void mousePressed(MouseEvent e) 
{
  if (!isLoading)
  {
    delay(10);
    if (state != 1) 
    {
      for (Widget widget : screens.get(state).widgets)
      {
        widget.getEvent(e);
      }
    }
    //Going from spreadsheet to profile
    if (state == 3 && !spreadsheet.getValue().equals("")) //by D. Guzowski
    {
      query = spreadsheet.getValue();
      boolean alreadyMade = false;
      for (Profile profile : profiles)
      {
        if (query.equals(profile.getTicker()))
        {
          alreadyMade = true;
          profileIndex = profiles.indexOf(profile);
          state = 1;
        }
      }
      if (!alreadyMade)
      {
        thread("profileCreate");
      }
    }
    
    if(trendsScreen != null)
    {
      trendsScreen.widgets.get(0).getEvent(e);
    }
  }
}

//For "scrolling" through stocks screen
void mouseWheel(MouseEvent e)
{
  if (!isLoading)
  {
    screens.get(state).getEvent(e);
  }
}
