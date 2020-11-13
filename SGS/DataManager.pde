//Class created by O. Gallagher, modified by D. Guzowski
//Implements SQL for data management
//Uses isLoading variable frequently

import java.sql.*;
import org.sqlite.*;

class DataManager
{
  // Part of the SQL library for use when connecting to a database.
  Connection connection;
  Statement statement;

  // The constructor takes the url of the database and establishes a connection.
  DataManager(String dburl) 
  {
    try 
    {
      connection = DriverManager.getConnection(dburl);
      statement = connection.createStatement();
    } 
    catch (Exception e) 
    { 
      e.printStackTrace();
    }
  }
  
  // Method for returning growthgraph data for a date in a table
  Table growthGraph(String date) 
  {
    try 
    {
      String sql = "SELECT (daily_prices.close/daily_prices.open-1),stocks.ticker,stocks.name,stocks.industry ";
      sql += "FROM daily_prices INNER JOIN stocks ON daily_prices.ticker=stocks.ticker WHERE date='%s' ";
      sql += "GROUP BY daily_prices.ticker ORDER BY volume LIMIT 50;"; //D. Guzowski: removed " ORDER BY (daily_prices.close/daily_prices.open-1)/3.65 DESC LIMIT 15" to keep an unordered list without a limit.
      sql = String.format(sql, date);
      ResultSet resultSet = statement.executeQuery(sql);
      return new Table(resultSet);
    } 
    catch (Exception e) 
    {
      e.printStackTrace();
      return null;
    }
  }

  // Method for returning piechart data for a date in a table
  Table piechart(String date) 
  {
    try 
    {
      String sql = "SELECT daily_prices.volume,stocks.ticker,stocks.name,stocks.industry ";
      sql += "FROM daily_prices INNER JOIN stocks ON daily_prices.ticker=stocks.ticker WHERE date='%s' ";
      sql += "ORDER BY volume DESC LIMIT 15;";
      sql = String.format(sql, date);
      ResultSet resultSet = statement.executeQuery(sql);
      return new Table(resultSet);
    } 
    catch (Exception e) 
    {
      e.printStackTrace();
      return null;
    }
  }

  // Method for returning profile data in a table.
  Table profile(String term, int setting) 
  {
    try 
    {
      String cutOff = "";
      switch(setting) 
      {
      case 0: 
        cutOff = "2018-08-16"; 
        break;
      case 1: 
        cutOff = "2018-07-23"; 
        break;
      case 2: 
        cutOff = "2018-05-23"; 
        break;
      case 3: 
        cutOff = "2018-02-23"; 
        break;
      case 4: 
        cutOff = "2017-08-23"; 
        break;
      case 5: 
        cutOff = "2013-08-23"; 
        break;
      case 6:
      default: 
        cutOff = "";
      }

      String sql;
      sql = "SELECT date as 'Date',adj_close as 'Adj_close',open as 'Open',close as 'Close',high as 'High',low as 'Low',volume as 'Volume' ";
      sql += "FROM daily_prices WHERE ticker='%s' AND date>'%s' ORDER BY date ASC;";
      sql = String.format(sql, term, cutOff);
      ResultSet resultSet = statement.executeQuery(sql);
      return new Table(resultSet);
    } 
    catch (Exception e) 
    { 
      e.printStackTrace(); 
      return null;
    }
  }

  // Method for a lineplot to be used in comparison graphs
  Table linePlot(String ticker, String date, String date1) 
  {
    try 
    {
      String sql;
      sql = "SELECT date as 'Date',adj_close as 'Adj_close',open as 'Open',close as 'Close',high as 'High',low as 'Low',volume as 'Volume', ticker as 'Ticker' ";
      sql += "FROM daily_prices WHERE ticker='%s' AND date BETWEEN '%s' AND '%s' ORDER BY date ASC;";
      sql = String.format(sql, ticker, date, date1);
      ResultSet resultSet = statement.executeQuery(sql);
      return new Table(resultSet);
    } 
    catch (Exception e) 
    { 
      e.printStackTrace(); 
      println("No data found");
      return null;
    }
  }
  
  // Method for checking profile exists
  boolean profileExists(String term) 
  {
    try 
    {
      String sql;
      sql = "SELECT date as 'Date',adj_close as 'Adj_close',open as 'Open',close as 'Close',high as 'High',low as 'Low',volume as 'Volume' ";
      sql += "FROM daily_prices WHERE ticker='%s' ORDER BY date ASC;";
      sql = String.format(sql, term);
      ResultSet resultSet = statement.executeQuery(sql);
      return new Table(resultSet).getRowCount()>0;
    } 
    catch (Exception e) 
    { 
      e.printStackTrace(); 
      return false;
    }
  }

  // Method for returning profile data in a table.
  Table profile(String term) 
  {
    try 
    {
      String sql;
      sql = "SELECT date as 'Date',adj_close as 'Adj_close',open as 'Open',close as 'Close',high as 'High',low as 'Low',volume as 'Volume' ";
      sql += "FROM daily_prices WHERE ticker='%s' ORDER BY date ASC;";
      sql = String.format(sql, term);
      ResultSet resultSet = statement.executeQuery(sql);
      return new Table(resultSet);
    } 
    catch (Exception e) 
    { 
      e.printStackTrace(); 
      return null;
    }
  }
  
  // Method for returning stocks data in a table.
  Table stocks() 
  {
    try 
    {
      String sql = "SELECT stocks.ticker as 'Ticker', stocks.name as 'Company Name', stocks.sector as 'Sector' FROM daily_prices ";
      sql += "INNER JOIN stocks ON stocks.ticker = daily_prices.ticker GROUP BY daily_prices.ticker;";
      sql = String.format(sql);
      ResultSet resultSet = statement.executeQuery(sql);
      return new Table(resultSet);
    } 
    catch (Exception e) 
    {
      e.printStackTrace(); 
      return null;
    }
  }

  // Method for returning stocks data in a table.
  Table stocks(String term) 
  {
    try 
    {
      String sql = "SELECT stocks.ticker as 'Ticker', stocks.name as 'Company Name', stocks.sector as 'Sector' FROM daily_prices ";
      sql += "INNER JOIN stocks ON stocks.ticker = daily_prices.ticker ";
      sql += "WHERE stocks.name LIKE '%%%%%s%%%%' OR stocks.ticker LIKE '%%%%%s%%%%' OR stocks.sector LIKE '%%%%%s%%%%' GROUP BY daily_prices.ticker;";
      sql = String.format(sql, term, term, term);
      ResultSet resultSet = statement.executeQuery(sql);
      return new Table(resultSet);
    } 
    catch (Exception e) 
    { 
      e.printStackTrace(); 
      return null;
    }
  }

  // Method for returning stock info in a string.
  String stockInfo(String term, int setting) 
  {
    try 
    {
      String sql = "SELECT stocks.%s FROM daily_prices JOIN stocks ON daily_prices.ticker = stocks.ticker ";
      sql += "WHERE daily_prices.ticker='%s' LIMIT 1;";
      String type = "";
      switch(setting) 
      {
      case 0: 
        type = "industry"; 
        break;
      case 1: 
        type = "sector"; 
        break;
      case 2: 
        type = "exchange"; 
        break;
      case 3:
      default: 
        type = "name";
      }
      sql = String.format(sql, type, term);
      ResultSet resultSet = statement.executeQuery(sql);
      return resultSet.getString(1);
    } 
    catch (Exception e) 
    { 
      e.printStackTrace();
      return "";
    }
  }
}
