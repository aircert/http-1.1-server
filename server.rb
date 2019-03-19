require 'socket'
require 'uri'

# Files will be served from this directory
WEB_ROOT = './public'

# Map extensions to their content type
CONTENT_TYPE_MAPPING = {
  'html' => 'text/html',
  'txt' => 'text/plain',
  'png' => 'image/png',
  'jpg' => 'image/jpeg'
}

# Treat as binary data if content type cannot be found
DEFAULT_CONTENT_TYPE = 'application/octet-stream'

# This helper function parses the extension of the
# requested file and then looks up its content type.

def content_type(path)
  ext = File.extname(path).split(".").last
  CONTENT_TYPE_MAPPING.fetch(ext, DEFAULT_CONTENT_TYPE)
end

# This helper function parses the Request-Line and
# generates a path to a file on the server.

def requested_file(request_line)
  request_uri  = request_line.split(" ")[1]
  path         = URI.unescape(URI(request_uri).path)

  clean = []

  # Split the path into components
  parts = path.split("/")

  parts.each do |part|
    # skip any empty or current directory (".") path components
    next if part.empty? || part == '.'
    # If the path component goes up one directory level (".."),
    # remove the last clean component.
    # Otherwise, add the component to the Array of clean components
    part == '..' ? clean.pop : clean << part
  end

  # return the web root joined to the clean path
  File.join(WEB_ROOT, *clean)
end



# Determine if any other request type outside of GET
def parse(request)
  method, path, version = request.lines[0].split
  {
    path: path,
    method: method,
    headers: parse_headers(request)
  }
end

def parse_headers(request)
  headers = {}
  request.lines[1..-1].each do |line|
    return headers if line == "\r\n"
    header, value = line.split
    header        = normalize(header)
    headers[header] = value
  end

  def normalize(header)
    header.gsub(":", "").downcase.to_sym
  end
end

# Except where noted below, the general approach of
# handling requests and generating responses is
# similar to that of the "Hello World" example
# shown earlier.

server = TCPServer.new('localhost', 2345)

loop do
  Thread.start(server.accept) do |socket|
    request_line = socket.gets

    parse_response = parse(request_line)

    if parse_response[:method] != "GET"
      message = "Forbidden\n"
      
      socket.print "HTTP/1.1 400 Forbidden Request\r\n" +
      "Content-Type: text/plain\r\n" +
      "Content-Length: #{message.size}\r\n" +
      "Connection: close\r\n"

      socket.print "\r\n"

      socket.print message
    else

      path = requested_file(request_line)
      path = File.join(path, 'index.html') if File.directory?(path)

      # Make sure the file exists and is not a directory
      # before attempting to open it.
      if File.exist?(path) && !File.directory?(path)
        File.open(path, "rb") do |file|
          socket.print "HTTP/1.1 200 OK\r\n" +
          "Content-Type: #{content_type(file)}\r\n" +
          "Content-Length: #{file.size}\r\n" +
          "Connection: close\r\n"

          socket.print "\r\n"

          # write the contents of the file to the socket
          IO.copy_stream(file, socket)
        end
      else
        message = "File not found\n"

        # respond with a 404 error code to indicate the file does not exist
        socket.print "HTTP/1.1 404 Not Found\r\n" +
        "Content-Type: text/plain\r\n" +
        "Content-Length: #{message.size}\r\n" +
        "Connection: close\r\n"

        socket.print "\r\n"

        socket.print message
      end
    end

    socket.close
  end
end