public java.lang.String encodeData(com.android.volley.NetworkResponse response) {
  try {
    java.lang.String json = new java.lang.String(response.data, "UTF-8");
    return json;
  } catch (java.io.UnsupportedEncodingException e) {
    return null;
  }
}
