import "chrome_utils"

this = new chrome_utils.Dispatcher

this.add_file_route "/", "homepage/homepage.gmi"
this.add_file_route "/about", "homepage/about.gmi"
this.add_file_route "/keys", "homepage/keys.gmi"

return this