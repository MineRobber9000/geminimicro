from http.server import test, BaseHTTPRequestHandler
from pathlib import PurePosixPath
from traceback import format_exc, format_exception_only
import urllib.parse as urlparse
from gemini import request
from struct import pack as _struct_pack

# not sure this is actually needed but AV-98 does it so
urlparse.uses_relative.append("gemini")
urlparse.uses_netloc.append("gemini")
# either way we don't need the rest of the module after this
urljoin = urlparse.urljoin
urlparse = urlparse.urlparse

def path_to_request(_path):
    try:
        path = PurePosixPath(_path.lstrip("/"))
        assert len(path.parts)>0, "Usage: /<host>[:<port>]/<path>"
        url = None
        end = "/" if _path.endswith("/") else ""
        if len(path.parts)==1:
            url = urlparse(f"gemini://{path.parts[0]}/")
        else: # len(path.parts)>1
            url = urlparse(f"gemini://{path.parts[0]}/{path.relative_to(path.parts[0])!s}{end}")
        print(url.geturl())
        assert url._userinfo == (None, None), "gemini:// URLs cannot contain userinfo component"
        assert url.fragment == "", "gemini:// URLs as sent to the server should not contain fragments"
        n = 0
        while n<5:
            resp = request(url)
            header, crlf, body = resp.partition(b'\r\n')
            assert crlf==b'\r\n', "Malformed server response"
            if header[:1]==b'3': # redirect
                url = urlparse(urljoin(url.geturl(),header[3:].decode()))
                print(f"redirect {url!s} {n!s}")
                n+=1
                continue
            else:
                return header, body, url.geturl().encode("utf-8")
    except AssertionError as e:
        return b'43 '+e.args[0].encode("utf-8"), b'', url.geturl().encode("utf-8") if url else _path.encode("utf-8")
    except Exception as e:
        print(format_exc())
        return b'43 '+format_exception_only(e)[0].strip().encode("utf-8"), b'', url.geturl().encode("utf-8") if url else _path.encode("utf-8")

class GeminiHTTPRequestHandler(BaseHTTPRequestHandler):
    def _format(self,header,body,url):
        return body+url+header+_struct_pack("<II",len(body),len(url))
    def do_GET(self):
        header, body, url = path_to_request(self.path)
        self.send_response(200)
        self.send_header("content-type","application/octet-stream")
        self.end_headers()
        self.wfile.write(self._format(header, body, url))
        self.wfile.flush()

if __name__=="__main__":
    test(GeminiHTTPRequestHandler)