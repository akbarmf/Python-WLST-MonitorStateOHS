from java.io import FileInputStream

def main():
  propInputStream = FileInputStream(sys.argv[1])
  configProps = Properties()
  configProps.load(propInputStream)
  
  username=configProps.get("importUser")
  password=configProps.get("importPassword")
  listen_addr=configProps.get("listen_addr")
  listen_port=configProps.get("listen_port")
  domain_name=configProps.get("domain_name")
  server_name=configProps.get("server_name")
  nm_type=configProps.get("nm_type")
  
  nmConnect(username, password, listen_addr, listen_port, domain_name, nmType=nm_type)

  checkState(server_name)
  
def checkState(server_name):
	items = server_name.split(',')

	print('\n')

	for item in items:

		redirect('/dev/null','false')
		state=nmServerStatus(serverName=item, serverType='OHS')

		print('OHS Instance : ' + item + '\tStatus : ' + state )

	print('\n')
	
main()
