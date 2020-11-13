//Class made by K. Wang, modified by D. Guzowski
//Used for entering a date, for finding data on a particular date

class DateWidget extends Widget
{
  float x, y, px, py;
  float xpos;
  float x2, y2;
  float x3, y3;
  float smallBoxX;
  float sliderWidth, sliderHeight;
  float radius;
  int rangeDay;
  float dayValue, monthValue, yearValue;
  float colourValue;
  boolean lock, lock2, lock3;
  int w, h;
  
  color labelColour;
  
  DateWidget(float px, float py, float widgetWidth, float widgetHeight, String label, int event) 
  {
    super(px, py, widgetWidth, widgetHeight, label, event);
    w = 0;
    h = 0;
    this.px = px;
    this.py = py;
    this.widgetWidth = widgetWidth;
    this.widgetHeight = widgetHeight;
    this.rangeDay = 31;
    lock = false;
    lock2 = false;
    lock3 = false;
    this.labelColour = color(0);
  }
  
  void draw() 
  {
    sliderWidth = widgetWidth * width;
    sliderHeight = widgetHeight * height;
    radius = sliderWidth/5;
        
    if(w != width || h != height) 
    {
      w = width;
      h = height;
      x = px*width;
      y = py*height;
      xpos = px*width;
      x2 = px*width;
      y2 = y + widgetHeight * height*6;
      x3 = px*width;
      y3 = y2 + widgetHeight * height*6;
      smallBoxX = xpos + sliderWidth + 0.035*width;
    }
    
    changeDaysInMonth();
    update();
    pushStyle();
    fill(100, 50);
    noStroke();
    rect(xpos-0.02*width, y-0.04*height, 0.22*width, 0.2*height, 8);
    popStyle();
    drawSliderDay();
    drawSliderMonth();
    drawSliderYear();
  }
  
  //draws the slider for day
  void drawSliderDay() 
  {
    pushStyle();
    float endX = xpos + sliderWidth;
    colourValue = map(x, xpos, endX, 230, 255);
    dayValue = map(colourValue, 230, 255, 1, rangeDay);
    
    //draw base line
    noStroke();
    fill(255, 175);
    rect(xpos, y, sliderWidth+radius, sliderHeight, 25, 25, 25, 25);
    
    //draw button
    fill(20, 220, 20, 150);
    ellipse(x+radius/2, y+sliderHeight/2, radius, radius);
    pushStyle();
    textAlign(CENTER, CENTER);
    textSize(((0.02*width/2 + 0.02*height/2))/1.4);
    fill(0);
    text("D", x + radius/2, y+2);
    popStyle();
    
    //display value
    textSize(((0.02*width/2 + 0.02*height/2)));
    fill(0);
    
    //draws box beside slider showing value
    fill(255, 175);
    noStroke();
    rect(smallBoxX, y-(0.05*height)/3, 0.05*width, 0.04*height, 5, 5, 5, 5);
    fill(labelColour);
    textAlign(TOP, LEFT);
    text(String.format("%02d", int(dayValue)), xpos + sliderWidth + 0.05*width, y + 0.015*height);
    
    popStyle();
  }
  
  //draws the slider for month
  void drawSliderMonth() 
  {
    pushStyle();
    
    float endX = xpos + sliderWidth;
    colourValue = map(x2, xpos, endX, 230, 255);
    monthValue = map(colourValue, 230, 255, 1, 12);
    
    //draw base line
    noStroke();
    fill(255, 175);
    rect(xpos, y2, sliderWidth+radius, sliderHeight, 25, 25, 25, 25);
    
    //draw button
    fill(20, 150, 255, 150);
    ellipse(x2+radius/2, y2+sliderHeight/2, radius, radius);

   // drawGradient(x2+1, y2-sliderHeight/2+1, radius-2, buttonHeight-2, color(255), color(0, 50, 150), 1);
    pushStyle();
    textAlign(CENTER, CENTER);
    textSize(((0.02*width/2 + 0.02*height/2))/1.4);
    fill(0);
    text("M", x2 + radius/2, y2+2);
    popStyle();
    
    //display value
    textSize(((0.02*width/2 + 0.02*height/2)));
    fill(0);
    
    fill(255, 175);
    noStroke();
    rect(smallBoxX, y2-(0.05*height)/3, 0.05*width, 0.04*height, 5, 5, 5, 5);
    fill(0);
    textAlign(TOP, LEFT);
    text(String.format("%02d",int(monthValue)), xpos + sliderWidth + 0.05*width, y2 + 0.015*height);
    
    popStyle();
  }
  
  //draws the slider for year
  void drawSliderYear() 
  {
    pushStyle();
    
    float endX = xpos + sliderWidth;
    colourValue = map(x3, xpos, endX, 230, 255);
    yearValue = map(colourValue, 230, 255, 1970, 2018);
    
    //draw base line
    noStroke();
    fill(255, 175);
    rect(xpos, y3, sliderWidth+radius, sliderHeight, 25, 25, 25, 25);
    
    //draw button
    fill(255, 75, 0, 150);
    ellipse(x3+radius/2, y3+sliderHeight/2, radius, radius);

    pushStyle();
    textAlign(CENTER, CENTER);
    textSize(((0.02*width/2+0.02*height/2))/1.4);
    fill(0);
    text("Y", x3 + radius/2, y3+2);
    popStyle();
    
    //display value
    textSize(((0.02*width/2 + 0.02*height/2)));
    
    fill(255, 175);
    noStroke();
    rect(smallBoxX, y3-(0.05*height)/3, 0.05*width, 0.04*height, 5, 5, 5, 5);
    fill(0);
    textAlign(TOP, LEFT);
    text(int(yearValue), xpos+sliderWidth + 0.04*width, y3 + 0.015*height);
    
    popStyle();
  }
  
  //Updates the position of the slider
  void update() 
  {
    float mX = constrain(mouseX-radius/4, xpos, xpos+sliderWidth);
    float mX2 = constrain(mouseX-radius/4, xpos, xpos+sliderWidth);
    float mX3 = constrain(mouseX-radius/4, xpos, xpos+sliderWidth);
    if(lock) {
      x = mX;
    }
    if(lock2) {
      x2 = mX2;
    }
    if(lock3) {
      x3 = mX3;
    }
  }
  
  //checks how many days there should be in each month and changes the range of the day slider
  void changeDaysInMonth() 
  {
    if(int(monthValue) == 4 || int(monthValue) == 6 || int(monthValue) == 9 || int(monthValue) == 11) 
    {
     rangeDay = 30;
    }
    else if(int(monthValue) == 2) 
    {
     int currYear = int(yearValue);
     if(((currYear % 4 == 0) && (currYear % 100 != 0)) || (currYear % 400 == 0)) 
     {
      rangeDay = 29;
     }
     else 
     {
      rangeDay = 28; 
     }
    }
    else 
    {
     rangeDay = 31; 
    }
  }
  
  //returns the current date as a String
  String getDate() 
  {
    return int(yearValue) + "-" + String.format("%02d", int(monthValue)) + "-" + String.format("%02d", int(dayValue));
  }
  
  //returns event
  int getEvent(MouseEvent e) 
  {
    boolean isOverDay = dist(mouseX, mouseY, x, y) <= radius;
    boolean isOverMonth = dist(mouseX, mouseY, x2, y2) <= radius;
    boolean isOverYear = dist(mouseX, mouseY, x3, y3) <= radius;
    switch(e.getAction())
    {
    case MouseEvent.PRESS:
      if (isOverDay)
      {
        lock = true;
      }
      else if (isOverMonth)
      {
        lock2 = true;
      }
      else if (isOverYear)
      {
        lock3 = true;
      }
      break;
    case MouseEvent.RELEASE:
      lock = false;
      lock2 = false;
      lock3 = false;
      break;
    }
    return EVENT_NULL;
  }
  
  //returns key event
  int getEvent(KeyEvent e)
  {
    switch(e.getAction())
    {
    case KeyEvent.PRESS:
      if(keyCode == ENTER || keyCode == RETURN) 
      {
        query=getDate();
        return EVENT_DATE;
      }
      break;
    }
    return EVENT_NULL;
  }
}
