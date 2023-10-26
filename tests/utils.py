"""Requests Session with Base URL support

https://github.com/requests/toolbelt/blob/master/requests_toolbelt/sessions.py
"""


import requests
from urllib.parse import urljoin


class BaseUrlSession(requests.Session):
    base_url = None

    def __init__(self, base_url=None):
        if base_url:
            self.base_url = base_url
        super(BaseUrlSession, self).__init__()

    def request(self, method, url, *args, **kwargs):
        """Send the request after generating the complete URL."""
        url = self.create_url(url)
        return super(BaseUrlSession, self).request(method, url, *args, **kwargs)

    def prepare_request(self, request, *args, **kwargs):
        """Prepare the request after generating the complete URL."""
        request.url = self.create_url(request.url)
        return super(BaseUrlSession, self).prepare_request(request, *args, **kwargs)

    def create_url(self, url):
        """Create the URL based off this partial path."""
        return urljoin(self.base_url, url)
