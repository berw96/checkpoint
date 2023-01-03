from bs4 import BeautifulSoup as bs
import requests
import regex as re
import json
import asyncio

# ARCHIVE URLs, contain the first page of each archive.
_INDEPENDENT_URL    = "independent.co.uk/archive/2022-01-01"
_SUN_URL            = "thesun.co.uk/page/1/?s=Russia"
_DAILY_MAIL_URL     = "dailymail.co.uk/home/sitemaparchive/day_20220101.html"
_TIMES_URL          = "thetimes.co.uk/search?filter=past_year&p=1&q=Russia&source=nav-desktop"

# SITE ADDRESSES - Article URLs should be appended onto these when web scraping.
_INDEPENDENT_ADDRESS    = "independent.co.uk/"
_SUN_ADDRESS            = "thesun.co.uk/"
_DAILY_MAIL_ADDRESS     = "dailymail.co.uk/"
_TIMES_ADDRESS          = "thetimes.co.uk/"

# def scan_for_articles(url, topic):
#     pass

def query_soup(url, jar = None):
    # Stores additional information pertaining to a HTTP request
    # we would like to invoke for a webpage's HTML content.
    http_headers = {
        "update-insecure-requests" : "1"
    }

    # Define an empty list which will store all articles (URLs to)
    # mentioning Russia for a given newspaper.
    articles = []

    # The Daily Mail and The Independent both incorporate dates into their URLs
    if(url.__contains__(_INDEPENDENT_URL) or url.__contains__(_DAILY_MAIL_URL)):
        # For URLs which use the yyyy-mm-dd format
        # Cycle through the 12 months in the year.
        for i in range(1,13):
            # Set number of days to scan based on month index.
            days_of_the_month = 0
            if(
                i == 1 or 
                i == 3 or 
                i == 5 or 
                i == 7 or 
                i == 8 or 
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
                    # Check if the string contains any mentions of Russia.
                    if(str(a).__contains__("Russia")):
                        # Query the 'href' link associated with it.
                        print(a['href'])
                        # Append article to list.
                        articles.append(a['href'])
                    
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
    
    # The Sun and The Times both specify page numbers in their URLs
    elif(url.__contains__(_SUN_URL) or url.__contains__(_TIMES_URL)):
        if(url.__contains__(_SUN_URL)):
            # Scan 1000 pages of The Sun for articles relating to Russia.
            for i in range(1, 473):
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
                
                # Retreive all the publication dates for the current page
                publication_dates = soup.find_all('div', class_ = "search-date")
                    
                for date in publication_dates:
                    if(date.get_text().__contains__("2022")):
                        # Find all occurances of an <a> tag.
                        # These include 'href' attributes for article links.
                        content = soup.find_all('a', class_ = "text-anchor-wrap")
                        for a in content:
                            # Cast soup content to a string.
                            # Check if the string contains any mentions of Russia.
                            if(str(a).__contains__("Russia")):
                                # Query the 'href' link associated with it.
                                print(date.get_text())
                                print(a['href'])
                                # Append article to list.
                                articles.append(a['href'])
                    # Stop searching once we've reached 2021.
                    elif(date.get_text().__contains__("2021")):
                        break
                
                url = url.replace("page/" + str(i), "page/" + str(i+1))
        
        
        
        
    
    print("Articles on Russia found: %d" % len(articles)) 

query_soup("https://" + _SUN_URL)
