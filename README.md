#Rush Hour#
##Development Team##
Ilana Corson
Lucy Fox
Erin Greenhalgh


##Project Purpose##
The purpose of this project was to build a web application utilizing Sinatra and Active Record. The application receives and analyze web traffic information for different clients.

##Using the App##
Clients can register to our application via a curl request, sending their client id and root url as parameters in their POST request.

For example:
`curl -i -d 'identifier=jumpstartlab&rootUrl=http://jumpstartlab.com'  http://localhost:9393/sources`

Once they have registered to our application, clients can then send information about a specific user request to a URL of their site.

For example:
`curl -i -d 'payload={"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName":"socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}' http://localhost:9393/sources/jumpstartlab/data`

They can then see statistics about web traffic on their site as a whole. Statistics include information about:
* URL response times
* most frequent user request types
* most frequent urls requested
* user machine information, including operating system, browser, and screen resolutions

Clients can also view information for a specific URL, including:
* response times data
* associated request verbs
* top user agents

Finally, clients can view a 24 hour breakdown of requests received per hour.

To view their dashboard and specific URL information, clients send a GET request to a URL specific to them.

For example, if the client is Jumpstartlab, they can view their dashboard at
`http://localhost:9393/sources/jumpstartlab/`.
They can view data for a specific URL, say the blog page, at
`http://localhost:9393/sources/jumpstartlab/urls/blog`.
Finally, they can view the 24 hour traffic breakdown for a given event, say a socialLogin, at `http://localhost:9393/sources/jumpstartlab/events/socialLogin`.

Any request made to an incorrect URL will direct to an error page.

##Project Spec##
For complete project details:
https://github.com/turingschool/curriculum/blob/master/source/projects/rush_hour.md
