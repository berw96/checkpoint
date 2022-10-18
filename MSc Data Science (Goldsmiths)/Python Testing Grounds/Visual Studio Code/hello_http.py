from ipaddress import ip_address
import requests
import asyncio

localhost = "localhost"
localhost_ip = ip_address("127.0.0.1")
http_timeout = 10

async def get_web_http(url = localhost):
    """Queries a webpage from a specified URL using HTTP.
    Returns localhost (127.0.0.1) by default."""
    webpage = requests.get(url)
    print(webpage.text)

async def get_web_json_http(url = localhost):
    """Queries a webpage as a JSON object.
    Returns localhost (127.0.0.1) by default."""
    webpage_json = requests.get(url)
    print(webpage_json.json())

async def main():
    """Driver function."""
    print("loading...")
    task1 = asyncio.create_task(get_web_http("https://youtube.com"))

    try:
        await asyncio.wait_for(task1, timeout = http_timeout)
        print("loaded webpage")
    except:
        print("could not load webpage")

asyncio.run(main())
