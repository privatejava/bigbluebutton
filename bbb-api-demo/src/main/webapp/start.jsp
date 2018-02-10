<%@ page trimDirectiveWhitespaces="true" %>
<%@page import="java.util.*,java.io.*,java.net.*,java.util.logging.*, org.apache.http.*, org.apache.http.client.entity.*,org.apache.http.client.methods.*,org.apache.http.client.*,org.apache.http.impl.client.*, org.apache.http.message.*" errorPage="error.jsp"%>
<%@page import="org.apache.commons.io.IOUtils" %>
<%@page import="com.google.gson.reflect.TypeToken" %>
<%@page import="com.google.gson.Gson" %>
<%@page import="java.lang.reflect.Type" %>
<%@ include file="bbb_api.jsp"%>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%!
private static class TutortoneAPIResponse {
  private boolean status;
  private String message;
  private TutortoneUser data;
  public String toString(){
      return status+":"+message;
  }
}



private static class TutortoneUser{
  private String userId;
  private String name;
  private String title;
  private String email;
}
%>
<%
Map<String,Object> returnObj = new HashMap<String,Object>();
returnObj.put("success" , false);
String token = request.getParameter("token");
if (token != null) { 
    try {
        CloseableHttpClient client = HttpClients.createDefault();
        HttpPost httpPost = new HttpPost("http://api.tutortone.com/v1/auth");
        httpPost.addHeader("X-API-KEY", "k0k04og0c8os0s0404ooc4w8080448044c4ks044");
        List<NameValuePair> params = new ArrayList<NameValuePair>();
        params.add(new BasicNameValuePair("auth_token", token));
        httpPost.setEntity(new UrlEncodedFormEntity(params));
        CloseableHttpResponse res = client.execute(httpPost);
        if(res.getStatusLine().getStatusCode() == 200){
            String output = IOUtils.toString(res.getEntity().getContent(), "UTF-8"); 
            TutortoneAPIResponse apiResponse = new Gson().fromJson(output, TutortoneAPIResponse.class);
            //out.println("Hello "+apiResponse.data.name);
            String ip = BigBlueButtonURL.split("\\/bigbluebutton")[0];
            
            String meetingname = "Meeting "+ System.nanoTime();
            String html5url = ip + "/html5client/join";
            
            boolean isModerator = false;
            String defaultModeratorPassword = "mp";
	        String defaultAttendeePassword = "ap";
	        String defaultPassword = defaultAttendeePassword;
        	if (request.getParameter("moderator") != null) {
        		isModerator = Boolean.parseBoolean(request.getParameter("moderator"));
        		defaultPassword = defaultModeratorPassword;
        	}
            String meetingId = createMeeting( meetingname, null, defaultModeratorPassword, "Welcome "+apiResponse.data.name+"! (moderator only message)", defaultAttendeePassword, null, null );
            // Check if we have an existing meeting
        	if( meetingId.startsWith("Error ")) {
        		meetingId = meetingname;
        	}
        	String joinURL = getJoinMeetingURL(apiResponse.data.name, meetingId, defaultPassword, html5url);
        	
            if (joinURL.startsWith("http://") || joinURL.startsWith("https://")) {
                returnObj.put("success" , true);
                Map<String,String> data = new HashMap<String,String>();
                data.put("meetingUrl", joinURL);
                returnObj.put("data", data);
                //out.println("<script language=\"javascript\" type=\"text/javascript\">window.location.href=\""+joinURL+"\";</script>");
            }else{
                returnObj.put("message" , "Cannot join the meeting");
            }
            
        }else{
            returnObj.put("message" , "Cannot create join the meeting");
        }
        client.close();
    } catch (UnsupportedEncodingException ex) {
        //Logger.getLogger("start.jsp").log(Level.SEVERE, null, ex);
        returnObj.put("message" , ex.getMessage());
    } catch (IOException ex) {
        returnObj.put("message" , ex.getMessage());
    }
	
}else{
	out.println("Oops!! Either something went wrong from our end or you are in wrong place.");

}
out.println(new Gson().toJson(returnObj));
%>