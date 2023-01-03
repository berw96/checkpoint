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

def query_soup(url, jar = None):
    # Stores additional information pertaining to a HTTP request
    # we would like to invoke for a webpage's HTML content.
    http_headers = {
        "update-insecure-requests" : "1"
    }

    # Define an empty list which will store all articles (URLs to)
    # mentioning Russia for a given newspaper.
    articles = []

    if(url.__contains__(_INDEPENDENT_URL)):
        pass
    elif(url.__contains__(_SUN_URL)):
        pass
    elif(url.__contains__(_DAILY_MAIL_URL)):
        pass
    elif(url.__contains__(_TIMES_URL)):
        pass
    
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
            # If we are on the first day, don't iterate just yet.
            if(i < 10 and j > 1 and j < 10):
                url = url.replace("2022-0" + str(i) + "-0" + str(j-1),
                                  "2022-0" + str(i) + "-0" + str(j))
            elif(i >= 10 and j > 1 and j < 10):
                url = url.replace("2022-" + str(i) + "-0" + str(j-1),
                                  "2022-" + str(i) + "-0" + str(j))
            # Once the count for days reaches double digits, we ammend the
            # '0' so that it becomes numeric.
            elif(i < 10 and j == 10):
                url = url.replace("2022-0" + str(i) + "-0" + str(j-1),
                                  "2022-0" + str(i) + "-" + str(j))
            elif(i >= 10 and j == 10):
                url = url.replace("2022-" + str(i) + "-0" + str(j-1),
                                  "2022-" + str(i) + "-" + str(j))
            # Once the day exceeds 10, we use the new format to iterate.
            elif(i < 10 and j > 10):
                url = url.replace("2022-0" + str(i) + "-" + str(j-1),
                                  "2022-0" + str(i) + "-" + str(j))
            elif(i >= 10 and j > 10):
                url = url.replace("2022-" + str(i) + "-" + str(j-1),
                                  "2022-" + str(i) + "-" + str(j))
            
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
            for x in content:
                # Cast soup content to a string.
                # Check if the string contains any mentions of Russia.
                if(str(x).__contains__("Russia")):
                    # Query the 'href' link associated with it.
                    print(x['href'])
                    # Append article to list.
                    articles.append(x['href'])
                
        # Iterate month in URL and reset day to 1.
        # current_day stores the last scanned day so the .replace()
        # function has a reference as to what to set the day to
        # on the next iteration for the month.
        if(current_day >= days_of_the_month):
            if(i < 9):
                url = url.replace("2022-0" + str(i) + "-" + str(current_day),
                            "2022-0" + str(i+1) + "-01")
            elif(i == 9):
                url = url.replace("2022-0" + str(i) + "-" + str(current_day),
                            "2022-" + str(i+1) + "-01")
            elif(i >= 10):
                url = url.replace("2022-" + str(i) + "-" + str(current_day),
                            "2022-" + str(i+1) + "-01")
        
    print("Articles on Russia found: %d" % len(articles))
                

query_soup("https://" + _INDEPENDENT_URL)



                
            