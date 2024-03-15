# Web Development

## Status Codes

| Status Code | Description                                                                                                                          |
| ----------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| 200         | OK - The request has succeeded                                                                                                       |
| 201         | Created - The request has been fulfilled and resulted in a new resource being created                                                |
| 204         | No Content - The server has successfully fulfilled the request, but there is no content to send                                      |
| 400         | Bad Request - The server could not understand the request due to invalid syntax                                                      |
| 401         | Unauthorized - The client must authenticate itself to get the requested response                                                     |
| 403         | Forbidden - The client does not have access rights to the content, valid credentials are required                                    |
| 404         | Not Found - The server can't find the requested resource                                                                             |
| 405         | Method Not Allowed - The request method is not supported for the requested resource                                                  |
| 500         | Internal Server Error - The server encountered an unexpected condition that prevented it from fulfilling the request                 |
| 502         | Bad Gateway - The server received an invalid response from the upstream server while acting as a gateway or proxy                    |
| 503         | Service Unavailable - The server is currently unable to handle the request due to temporary overloading or maintenance of the server |

## Request / Response

- Blob (Binary large object)
  - Used as client-side JavaScript construct for dealing with raw binary data
  - Blobs are more relevant in client-side JavaScript environments, on server-side we more often handle raw data directly
  - Usage: Create an Object URL with URL.createObjectURL(blob) to reference the image data in a `<img>` tag's src attribute
- Base64 encoding

## Node.js

- Buffer
  - They are especially suitable for scenarios where you need to manipulate or process binary data in chunks or blocks.
- Stream
  - Streams are particularly useful for scenarios where you need to handle large amounts of data efficiently, without loading it all into memory at once.
    They're commonly used for file I/O, network communication, and data processing.
  - With a stream, the whole data is typically stored outside of the application's memory, such as in a file, network socket, or another data source.
    The stream abstraction allows you to work with this data piece by piece, without needing to load the entire dataset into memory at once.
