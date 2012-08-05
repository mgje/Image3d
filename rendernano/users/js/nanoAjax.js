

/*
 * Returns a new XMLHttpRequest object, or false if this browser
 * doesn't support it
 */
function newXMLHttpRequest() {

  var xmlreq = false;

  if (window.XMLHttpRequest) {

    // Create XMLHttpRequest object in non-Microsoft browsers
    xmlreq = new XMLHttpRequest();

  } else if (window.ActiveXObject) {

    // Create XMLHttpRequest via MS ActiveX
    try {
      // Try to create XMLHttpRequest in later versions
      // of Internet Explorer

      xmlreq = new ActiveXObject("Msxml2.XMLHTTP");

    } catch (e1) {

      // Failed to create required ActiveXObject

      try {
        // Try version supported by older versions
        // of Internet Explorer

        xmlreq = new ActiveXObject("Microsoft.XMLHTTP");

      } catch (e2) {

        // Unable to create an XMLHttpRequest with ActiveX
        alert("Can not create Msxmlhtto object!");
      }
    }
  }

  return xmlreq;
}


/*
 * Returns a function that waits for the specified XMLHttpRequest
 * to complete, then passes its XML response
 * to the given handler function.
 * req - The XMLHttpRequest whose state is changing
 * responseXmlHandler - Function to pass the XML response to
 */
function getReadyStateHandler(req, responseXmlHandler) {

  // Return an anonymous function that listens to the 
  // XMLHttpRequest instance
  return function () {

    // If the request's status is "complete"
    if (req.readyState == 4) {
      
      // Check that a successful server response was received
      if (req.status == 200) {

        // Pass the XML payload of the response to the 
        // handler function
        responseXmlHandler(req.responseXML);

      } else {

        // An HTTP problem has occurred
        alert("nanoAjax.js::HTTP error message: "+req.status);
      }
    }
  }
}




/*
 * Send POST or GET request to service at strURL, 
 * details parameters: todo
 *  
 */
function ajaxRequest(strHttpType, strURL,strRequestParams, CallbackFunction) {

  // Obtain an XMLHttpRequest instance
  var req = newXMLHttpRequest();

  // Set the handler function to receive callback notifications
  // from the request object
  var handlerFunction = getReadyStateHandler(req, CallbackFunction);
  req.onreadystatechange = handlerFunction;
  
  // Open an HTTP POST connection to the server.
  // Third parameter specifies request is asynchronous.
  //example:  req.open("POST", "RenderAnimation", true);
  req.open(strHttpType,strURL, true);

  // Specify that the body of the request contains form data
  //set header if request type is POST
  if(strHttpType.toString().toLowerCase() == "post"){
	  req.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
  }

  // Send form encoded data
  req.send(strRequestParams);
}

