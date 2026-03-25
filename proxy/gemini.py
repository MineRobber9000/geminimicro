import ssl, socket

ctx=ssl.create_default_context()
ctx.check_hostname=False
ctx.verify_mode=ssl.CERT_NONE

def connect(url,hostname,host,port):
	with socket.socket(socket.AF_INET,socket.SOCK_STREAM) as s:
		s.settimeout(5)
		ss = ctx.wrap_socket(s,server_hostname=hostname)
		try:
			ss.connect((host,port))
		except socket.timeout:
			return b'43 Connection timeout\r\n'
		except ConnectionRefusedError:
			return b'43 Connection refused\r\n'
		ss.send((url+"\r\n").encode("utf-8"))
		out = b""
		while (data:=ss.recv(1024)):
			out+=data
	return out

def request(url):
    return connect(url.geturl(), url.hostname, url.hostname, url.port or 1965)