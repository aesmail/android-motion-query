VOLLEY = Com::Android::Volley::Toolbox::Volley
REQUEST = Com::Android::Volley::Request
RESPONSE = Com::Android::Volley::Response
JSON_REQUEST = Com::Android::Volley::Toolbox::JsonRequest
HEADER_PARSER = Com::Android::Volley::Toolbox::HttpHeaderParser
PARSE_ERROR = Com::Android::Volley::ParseError
JSON_ARRAY = Org::Json::JSONArray
JSON_OBJECT = Org::Json::JSONObject

class AMQJSONFetch
  attr_accessor :context
  
  def initialize(context)
    self.context = context
    @request_queue = VOLLEY.newRequestQueue(context)
  end
  
  def get(url, &block)
    request = AMQJSONRequest.new(0, url, '', AMQResponseListener.new(&block), AMQErrorListener.new(&block))
    @request_queue.add(request)
  end
end

class AMQResponseListener
  attr_accessor :callback
  def initialize(&block)
    self.callback = block
  end
  
  def onResponse(response)
    if self.callback
      self.callback.call(AMQGeneralResponse.new(true, response))
    else
      puts "WARNING --- Please pass a block to the ResponseListener"
      puts "Response is:"
      puts response
    end
  end
end

class AMQErrorListener
  attr_accessor :callback
  def initialize(&block)
    self.callback = block
  end
  
  def onErrorResponse(error)
    if self.callback
      self.callback.call(AMQGeneralResponse.new(false, error))
    else
      puts "WARNING --- You did not pass a block to the ErrorResponse callback."
      puts "Actual error:"
      puts error
    end
  end
end


class AMQGeneralResponse
  attr_accessor :success, :result, :error
  
  def initialize(success, result)
    self.success = success
    self.result = result
  end
  
  def success?
    self.success
  end
end
