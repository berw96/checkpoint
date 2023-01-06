from bs4 import BeautifulSoup as bs
import requests
import regex as re
import sys

# ARCHIVE URLs, contain the first page of each archive.
_INDEPENDENT_URL    = "independent.co.uk/archive/2022-01-01"
_DAILY_MAIL_URL     = "dailymail.co.uk/home/sitemaparchive/day_20220101.html"

# SITE ADDRESSES - Article URLs should be appended onto these when web scraping their content.
_INDEPENDENT_ADDRESS    = "independent.co.uk/"
_DAILY_MAIL_ADDRESS     = "dailymail.co.uk/"

# Define an empty dictionary which will store all articles (URLs to)
# mentioning Russia for a given newspaper, and their publication dates.
_independent_articles   = {"URL" : [], "Date" : []}
_daily_mail_articles    = {"URL" : [], "Date" : []}

def query_soup(url, jar = None):
    # Stores additional information pertaining to a HTTP request
    # we would like to invoke for a webpage's HTML content.
    http_headers = {
        "update-insecure-requests" : "1"
    }

    # The Daily Mail and The Independent both incorporate dates into their URLs
    if(url.__contains__(_INDEPENDENT_ADDRESS) or url.__contains__(_DAILY_MAIL_ADDRESS)):
        # For URLs which use the yyyy-mm-dd format
        # Cycle through the 12 months in the year.
        january     = 1
        december    = 13
        for i in range(january, december):
            # Set number of days to scan based on month index.
            days_of_the_month = 0
            if(
                i == 1  or 
                i == 3  or 
                i == 5  or 
                i == 7  or 
                i == 8  or 
                i == 10 or 
                i == 12):
                days_of_the_month = 31
            elif(i == 2):
                days_of_the_month = 28
            elif(
                i == 4,
                i == 6,
                i == 9,
                i == 11
                ):
                days_of_the_month = 30
            print("Days set to %d" % days_of_the_month)
            
            # Cycle through days in the current month 'i' and update
            # the URL to incorporate the date.
            current_day = 0
            for j in range(1, days_of_the_month + 1):
                # If we are on the first day, don't iterate URL just yet.
                if(i < 10 and j > 1 and j < 10):
                    # Format the URL based on which website it is from.
                    # The Independent and The Daily Mail both share the same date
                    # format with the exception of delimiting dashes '-'.
                    if(url.__contains__(_INDEPENDENT_ADDRESS)):
                        url = url.replace("2022-0" + str(i) + "-0" + str(j-1),
                                          "2022-0" + str(i) + "-0" + str(j))
                    elif(url.__contains__(_DAILY_MAIL_ADDRESS)):
                        url = url.replace("20220" + str(i) + "0" + str(j-1),
                                          "20220" + str(i) + "0" + str(j))
                elif(i >= 10 and j > 1 and j < 10):
                    if(url.__contains__(_INDEPENDENT_ADDRESS)):
                        url = url.replace("2022-" + str(i) + "-0" + str(j-1),
                                          "2022-" + str(i) + "-0" + str(j))
                    elif(url.__contains__(_DAILY_MAIL_ADDRESS)):
                        url = url.replace("2022" + str(i) + "0" + str(j-1),
                                          "2022" + str(i) + "0" + str(j))
                # Once the count for days reaches double digits, we ammend the
                # '0' so that it becomes numeric.
                elif(i < 10 and j == 10):
                    if(url.__contains__(_INDEPENDENT_ADDRESS)):
                        url = url.replace("2022-0" + str(i) + "-0" + str(j-1),
                                          "2022-0" + str(i) + "-" + str(j))
                    elif(url.__contains__(_DAILY_MAIL_ADDRESS)):
                        url = url.replace("20220" + str(i) + "0" + str(j-1),
                                          "20220" + str(i) + "" + str(j))    
                elif(i >= 10 and j == 10):
                    if(url.__contains__(_INDEPENDENT_ADDRESS)):
                        url = url.replace("2022-" + str(i) + "-0" + str(j-1),
                                          "2022-" + str(i) + "-" + str(j))
                    elif(url.__contains__(_DAILY_MAIL_ADDRESS)):
                        url = url.replace("2022" + str(i) + "0" + str(j-1),
                                          "2022" + str(i) + "" + str(j))
                # Once the day exceeds 10, we use the new format to iterate.
                elif(i < 10 and j > 10):
                    if(url.__contains__(_INDEPENDENT_ADDRESS)):
                        url = url.replace("2022-0" + str(i) + "-" + str(j-1),
                                          "2022-0" + str(i) + "-" + str(j))
                    elif(url.__contains__(_DAILY_MAIL_ADDRESS)):
                        url = url.replace("20220" + str(i) + "" + str(j-1),
                                          "20220" + str(i) + "" + str(j))
                elif(i >= 10 and j > 10):
                    if(url.__contains__(_INDEPENDENT_ADDRESS)):
                        url = url.replace("2022-" + str(i) + "-" + str(j-1),
                                          "2022-" + str(i) + "-" + str(j))
                    elif(url.__contains__(_DAILY_MAIL_ADDRESS)):
                        url = url.replace("2022" + str(i) + "" + str(j-1),
                                          "2022" + str(i) + "" + str(j))
                
                current_day = j
                
                print("\nChecking articles for %s" % ("2022-" + str(i) + "-" + str(current_day)) + " @ " + url)   
                # Check for local cookie cache (jar)
                # This prevents us having to redownload the entire page content
                # every time this function is invoked.
                if jar:
                    webpage = requests.get(url, cookies = jar, headers = http_headers)
                else:
                    webpage = requests.get(url, headers = http_headers)
                    jar = requests.cookies.RequestsCookieJar()

                # Convert raw HTML into text strings.
                webpagedata = webpage.text
                soup = bs(webpagedata, "html.parser")
                
                # Find all occurances of an <a> tag.
                # These include 'href' attributes for article links.
                content = soup.find_all('a')
                for a in content:
                    # Cast soup content to a string.
                    # Check if the article contains any mentions of Russia or Ukraine, or their respective leaders.
                    if(
                        str(a).__contains__("Russia")   or 
                        str(a).__contains__("Ukraine")  or
                        str(a).__contains__("Putin")    or
                        str(a).__contains__("Zelensky")
                        ):
                        # Query the 'href' link associated with it.
                        print(a['href'])
                        # Append article to dictionary.
                        if(url.__contains__(_INDEPENDENT_ADDRESS)):
                            _independent_articles["URL"].append(_INDEPENDENT_ADDRESS + a['href'])
                            _independent_articles["Date"].append("2022-" + str(i) + "-" + str(current_day))
                        elif(url.__contains__(_DAILY_MAIL_ADDRESS)):
                            _daily_mail_articles["URL"].append(_DAILY_MAIL_ADDRESS + a['href'])
                            _daily_mail_articles["Date"].append("2022-" + str(i) + "-" + str(current_day))
                    
            # Iterate month in URL and reset day to 1.
            # current_day stores the last scanned day so the .replace()
            # function has a reference as to what to set the day to
            # on the next iteration for the month.
            if(current_day >= days_of_the_month):
                if(i < 9):
                    if(url.__contains__(_INDEPENDENT_ADDRESS)):
                        url = url.replace("2022-0" + str(i) + "-" + str(current_day),
                                          "2022-0" + str(i+1) + "-01")
                    elif(url.__contains__(_DAILY_MAIL_ADDRESS)):
                        url = url.replace("20220" + str(i) + "" + str(current_day),
                                          "20220" + str(i+1) + "01")    
                elif(i == 9):
                    if(url.__contains__(_INDEPENDENT_ADDRESS)):
                        url = url.replace("2022-0" + str(i) + "-" + str(current_day),
                                          "2022-" + str(i+1) + "-01")
                    elif(url.__contains__(_DAILY_MAIL_ADDRESS)):
                        url = url.replace("20220" + str(i) + "" + str(current_day),
                                          "2022" + str(i+1) + "01")
                elif(i >= 10):
                    if(url.__contains__(_INDEPENDENT_ADDRESS)):
                        url = url.replace("2022-" + str(i) + "-" + str(current_day),
                                          "2022-" + str(i+1) + "-01")
                    if(url.__contains__(_DAILY_MAIL_ADDRESS)):
                        url = url.replace("2022" + str(i) + "" + str(current_day),
                                          "2022" + str(i+1) + "01")

#query_soup("https://" + _INDEPENDENT_URL)
query_soup("https://" + _DAILY_MAIL_URL)