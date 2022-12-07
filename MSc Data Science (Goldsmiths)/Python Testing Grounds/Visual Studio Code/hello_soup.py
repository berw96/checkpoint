from bs4 import BeautifulSoup as bs
import requests
import json
import asyncio

def query_soup(url, jar = None):
    # Stores additional information pertaining to a HTTP request
    # we would like to invoke for a webpage's HTML content.
    http_headers = {
        "update-insecure-requests" : "1"
    }

    # Check for local cookie cache (jar)
    if jar:
        webpage = requests.get(url, cookies = jar, headers = http_headers)
    else:
        webpage = requests.get(url, headers = http_headers)
        jar = requests.cookies.RequestsCookieJar()

    webpagedata = webpage.text
    soup = bs(webpagedata, "html.parser")

    content = soup.find_all('div')
    for x in content:
        print(x)


query_soup("https://twitch.tv/xqc")


