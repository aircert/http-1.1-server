README.md

Verodin Challenge Project
=========================

Write a simple HTTP server from scratch in Ruby.  This should accept GET requests and respond with the static file at the requested path in a valid HTTP response.  The server will need to listen on a TCP socket and parse incoming requests in order to respond to them appropriately.

Run
-------

`ruby server.rb`

Test
----

Listens on port 2345
`open localhost:2345`

Scope
-----

* Support HTTP 1.1 requests
* Support GET requests only.  Respond with an appropriate HTTP response code to other request methods
* Serve only static files from the current working directory and subdirectories
* Support concurrent requests, ie don't block on responding to new requests while responding to a prior request.  However, this doesn't need to handle a large number of concurrent requests.
* Consider basic security vulnerabilities such as directory traversal
* Consider error conditions and writing for robustness (within reason).  Think about what happens if there are network errors or malformed HTTP requests from the client
* Wherever possible, use the appropriate RFCs as your guide
* Directory listing for requests that correspond to a directory and not a file is not required


Restrictions
------------

* Only the Ruby standard library is allowed, and nothing in the Net::HTTP module is allowed.  You'll need to write your own code for parsing HTTP requests and building HTTP responses.


Testing and Evaluation
----------------------

This will be judged for code quality, design choices, and how well it works according to the specification.  It will be tested with curl and Chrome, and it will also be sent invalid/malformed HTTP requests to see how it behaves to undesirable inputs.


Deliver
-------

* Either a tarball containing the source code, or a Github/Gitlab/other repo for the codebase where we can access it
* At the root of the source code directory, a README with any instructions needed for running the program
* In email, feel free to provide any additional information you think is relevant to the project.  This could be justifications for design decisions, or your thoughts on the project in general, or anything else.  This is not required, but we will read it if you write it.
* If you feel like the project is taking longer than a reasonable time, you can submit what you have done so far, along with an explanation of the parts that were omitted due to time constraints