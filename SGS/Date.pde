//Class by D. Guzowski
//General date class used for interpreting dates from dataset

static class Date 
{
  public static final String DEFAULT = "yyyy-MM-dd";
  public static final String AMERICAN = "MM-dd-yyyy";
  public static final String STANDARD = "dd-MM-yyyy";
  public static final int daysFromZeroTo1970 = 719528;
  protected static String dateFormat = DEFAULT;
  protected static String dateDivider = "-";

  //daysFromZeroTo1970 is the number of days from 01/01/0000 to 01/01/1970.

  //Calculates the total number of days since 01/01/0000 when given a String that fits the current date format.
  static int toDays(String dateString) //by D. Guzowski with parts creditted to O. Gallagher
  {
    String[] tempString = dateString.split("\\W+");
    if (tempString.length == 3)
    {
      String temp = "";
      String[] tempFormat = dateFormat.split("\\W+");
      for (int i = 0; i < tempFormat.length; i++)
      {
        switch(tempFormat[i])
        {
        case "dd":
          tempString[i] = String.format("%02d", Integer.parseInt(tempString[i]));
          break;
        case "MM":
          tempString[i] = String.format("%02d", Integer.parseInt(tempString[i]));
          break;
        case "yyyy":
          tempString[i] = String.format("%04d", Integer.parseInt(tempString[i]));
          break;
        default:
          break;
        }
        temp += tempString[i] + ((i != tempFormat.length-1)? "-" : "");
      }
      dateString = temp;

      String strYear = "";
      String strMonth = "";
      String strDay = "";
      for (int i=0; i < dateFormat.length(); i++)
      {
        char c = dateFormat.charAt(i);
        switch(str(c))
        {
        case "y": 
          strYear += dateString.charAt(i);
          break;
        case "M": 
          strMonth += dateString.charAt(i);
          break;
        case "d": 
          strDay += dateString.charAt(i);
          break;
        default:
          break;
        }
      }
      int tempYear = Integer.parseInt(strYear);
      int tempMonth = Integer.parseInt(strMonth);
      int tempDay = Integer.parseInt(strDay);   

      int tempTotalDays;
      int yearCutoff;
      if (tempYear < 1970)
      {
        yearCutoff = 0;
        tempTotalDays = 0;
      } else
      {
        yearCutoff = 1970;
        tempTotalDays = daysFromZeroTo1970;
      }
      while (true)
      {
        if ((tempYear <= yearCutoff && tempMonth == 1 && tempDay == 1))
        {
          break;
        }
        tempDay--;
        if (tempDay == 0)
        {
          tempMonth--;
          if (tempMonth == 0)
          {
            tempMonth = 12;
            tempYear--;
          }
          if (tempMonth == 1 || tempMonth == 3 || tempMonth == 5 || tempMonth == 7 || tempMonth == 8 || tempMonth == 10 || tempMonth == 12)
          {
            tempDay = 31;
          } else if (tempMonth == 4 || tempMonth == 6 || tempMonth == 9 || tempMonth == 11)
          {
            tempDay = 30;
          } else
          {
            if (((tempYear % 4 == 0) && (tempYear % 100 != 0)) || (tempYear % 400 == 0))
            {
              tempDay = 29;
            } else
            {
              tempDay = 28;
            }
          }
        }
        tempTotalDays++;
      }
      return tempTotalDays;
    } else
    {
      return 0;
    }
  }

  //Converts the total number of days to a date in the current date format.
  static String toDate(int totDays) //by D. Guzowski
  {
    int tempYear;
    int tempMonth = 1;
    int tempDay = 1;
    int tempTotalDays;
    if (totDays <= daysFromZeroTo1970)
    {
      tempTotalDays = totDays;
      tempYear = 0;
    } else
    {
      tempTotalDays = totDays - daysFromZeroTo1970;
      tempYear = 1970;
    }
    for (int i = tempTotalDays; i > 0; i--)
    {
      tempDay++;
      switch(tempMonth)
      {
      case 1:
      case 3:
      case 5:
      case 7:
      case 8:
      case 10:
      case 12:
        if (tempDay == 32)
        {
          tempMonth++;
          tempDay = 1;
        }
        break;
      case 4:
      case 6:
      case 9:
      case 11:
        if (tempDay == 31)
        {
          tempMonth++;
          tempDay = 1;
        }
        break;
      case 2:
        if (tempDay == 29 && !(((tempYear % 4 == 0) && (tempYear % 100 != 0)) || (tempYear % 400 == 0)))
        {
          tempMonth++;
          tempDay = 1;
        } else if (tempDay == 30 && (((tempYear % 4 == 0) && (tempYear % 100 != 0)) || (tempYear % 400 == 0)))
        {
          tempMonth++;
          tempDay = 1;
        }
        break;
      default:
        break;
      }

      if (tempMonth == 13)
      {
        tempYear++;
        tempMonth = 1;
      }
    }
    String dateString = "";
    String[] formatType = dateFormat.split("\\W+");
    for (int i = 0; i < formatType.length; i++)
    {
      if (formatType[i].equals("dd"))
      {
        dateString += String.format("%02d", tempDay) + ((i != formatType.length-1)? dateDivider : "");
      } else if (formatType[i].equals("MM"))
      {
        dateString += String.format("%02d", tempMonth) + ((i != formatType.length-1)? dateDivider : "");
      } else if (formatType[i].equals("yyyy"))
      {
        dateString += String.format("%04d", tempYear) + ((i != formatType.length-1)? dateDivider : "");
      }
    }
    return dateString;
  }

  //Returns the day of the week given the total days since 01/01/0000.
  static String weekDay(int totDays) //by D. Guzowski
  {
    int dayCheck;
    int totalDays;
    String dayOfTheWeek = "";
    if (totDays < daysFromZeroTo1970)
    {
      dayCheck = 0;
      totalDays = totDays;
    } else
    {
      dayCheck = 5;
      totalDays = totDays - daysFromZeroTo1970;
    }
    for (int i = totalDays; i > 0; i--)
    {
      if (++dayCheck == 7)
      {
        dayCheck = 0;
      }
    }
    switch(dayCheck)
    {
    case 0:
      dayOfTheWeek = "Saturday";
      break;
    case 1:
      dayOfTheWeek = "Sunday";
      break;
    case 2:
      dayOfTheWeek = "Monday";
      break;
    case 3:
      dayOfTheWeek = "Tuesday";
      break;
    case 4:
      dayOfTheWeek = "Wednesday";
      break;
    case 5:
      dayOfTheWeek = "Thursday";
      break;
    case 6:
      dayOfTheWeek = "Friday";
      break;
    default:
      dayOfTheWeek = "";
      break;
    }
    return dayOfTheWeek;
  }

  //Returns the day of the week given the Date as a string the fits the current date format.
  static String weekDay(String dateString) //by D. Guzowski
  {
    return weekDay(toDays(dateString));
  }

  //Allows to change the date format, any incorrect inputs will result in the DEFAULT format being set instead.
  static void setDateFormat(String format) //by D. Guzowski
  {
    boolean correctFormat = true;
    String[] formatType = format.split("\\W+");
    format = "";
    if (formatType.length == 3)
    {
      for (int i = 0; i < formatType.length; i++)
      {
        if ((!formatType[i].equalsIgnoreCase("dd") && !formatType[i].equalsIgnoreCase("MM") && !formatType[i].equalsIgnoreCase("yyyy")) || (formatType[0].equalsIgnoreCase(formatType[1]) || formatType[0].equalsIgnoreCase(formatType[2]) || formatType[1].equalsIgnoreCase(formatType[2])))
        {
          correctFormat = false;
          break;
        }

        if (formatType[i].equalsIgnoreCase("dd"))
        {
          format += formatType[i].toLowerCase() + ((i != formatType.length-1)? "-" : "");
        } else if (formatType[i].equalsIgnoreCase("MM"))
        {
          format += formatType[i].toUpperCase() + ((i != formatType.length-1)? "-" : "");
        } else if (formatType[i].equalsIgnoreCase("yyyy"))
        {
          format += formatType[i].toLowerCase() + ((i != formatType.length-1)? "-" : "");
        }
      }
    } else
    {
      correctFormat = false;
    }
    if (correctFormat)
    {
      dateFormat = format;
    } else
    {
      dateFormat = DEFAULT;
    }
  }

  static boolean isLeapYear(int yr) //by D. Guzowski
  {
    return (((yr % 4 == 0) && (yr % 100 != 0)) || (yr % 400 == 0));
  }
  
  //Restores default setting of the date class.
  static void setDefault()
  {
    dateDivider = "-";
    dateFormat = DEFAULT;
  }
  
  //Allows to manually set a symbol to divide the day-month-year.
  static void setDateDividerSymbol(String symbol)
  {
    if (symbol.length() != 1 || (symbol.charAt(0) > 'A' && symbol.charAt(0) < 'Z') || (symbol.charAt(0) > '0' && symbol.charAt(0) < '9'))
    {
      dateDivider = "-";
    } else
    {
      dateDivider = symbol;
    }
  }
}
