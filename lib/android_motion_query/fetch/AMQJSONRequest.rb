RESPONSE = Com::Android::Volley::Response
HEADER_PARSER = Com::Android::Volley::Toolbox::HttpHeaderParser
PARSE_ERROR = Com::Android::Volley::ParseError
JSON_ARRAY = Org::Json::JSONArray
JSON_OBJECT = Org::Json::JSONObject

class AMQJSONRequest < Com::Android::Volley::Toolbox::JsonRequest
  # NOTE see AMQJSONRequest.java for constructor and other method implementations
  def parseNetworkResponse(response)
    json = encodeData(response)
    begin
      if json[0] == '['
        RESPONSE.success( JSON_ARRAY.new(json), HEADER_PARSER.parseCacheHeaders(response) )
      elsif json[0] == '{'
        RESPONSE.success( JSON_OBJECT.new(json), HEADER_PARSER.parseCacheHeaders(response) )
      end
    rescue Org::Json::JSONException => e
      RESPONSE.error( PARSE_ERROR.new(e) )
    end
  end
end
