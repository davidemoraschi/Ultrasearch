
<!-- **********************************************************************
 globalsearch.jsp is an Oracle Ultra Search Query front end sample. You can
 customize it based on your preference. This sample page is written by
 using JavaServer Pages (JSP) and Oracle Ultra Search Query APIs, so that the
 dynamic part of the page can be separated from the static HTML.

*********************************************************************** -->


<!-- JSP page directives -->
<%@ page session="false" %>
<%@ page contentType="text/html; charset=iso-8859-1" %>
<%@ page import = "javax.servlet.ServletConfig" %>
<%@ page import = "java.sql.SQLException" %>
<%@ page import = "oracle.context.isearch.query.QueryTool" %>
<%@ page import = "oracle.context.isearch.query.Item" %>
<%@ page import = "oracle.context.isearch.query.QueryAttribute" %>
<%@ page import = "oracle.context.isearch.query.DatabaseConnectionManager" %>
<%!
  // this page
  private String queryPath = "gsearch.jsp";
  private String imagePath = "../images/";
  private String cssPath = "../styles.css";
  private String tablePath = "display.jsp?type=table";
  private String mailPath = "mail.jsp";
  private String filePath = "display.jsp?type=file";
  private String username = "ULTRASEARCH_USR";
  private String password = "nimda";
  private String propfile = "ultrasearch";
  private String sessLang = "Italian";
  private String pcharset = "iso-8859-1";

  // utility pages
  private final String addURLPath = "gutil.jsp?p_Page=0";
  private final String helpPath = "gutil.jsp?p_Page=1";
  private final String feedbackPath = "gutil.jsp?p_Page=2";

  // cached data
  private Item[] cachedAttrChoices = null;
  private Item[] cachedLangChoices = null;
  private Item[] cachedGroupChoices = null;

  boolean hasSession  = true;
  boolean hasInstance = true;
  boolean hasCompatibleVersion = true;
  boolean checkVersion = true;

  public void jspInit()
  {
    // initialize application state
    ServletConfig config = getServletConfig();
    String temp;
    temp = config.getInitParameter("username");
    if (temp != null)
      username = temp;
    temp = config.getInitParameter("password");
    if (temp != null)
      password = temp;
    temp = config.getInitParameter("property file");
    if (temp != null)
      propfile = temp;
    temp =config.getInitParameter("file display jsp");
    if (temp != null)
      filePath =temp;
    temp =config.getInitParameter("mail display jsp");
    if (temp != null)
      mailPath =temp;
    temp =config.getInitParameter("table display jsp");
    if (temp != null)
      tablePath =temp;
    temp = config.getInitParameter("session language");
    if (temp != null)
      sessLang = temp;
  }
%>
<jsp:useBean id="qt" scope="application" 
             class="oracle.context.isearch.query.QueryTool">
  <jsp:setProperty name="qt" 
       property="user" value="<%= username %>" />
  <jsp:setProperty name="qt" 
       property="password" value="<%= password %>" />
  <jsp:setProperty name="qt" 
       property="resourceFileName" value="<%= propfile %>"/>
  <jsp:setProperty name="qt"
       property="filePagePath" value="<%= filePath%>"/>
  <jsp:setProperty name="qt"
       property="tablePagePath" value="<%= tablePath%>"/>
  <jsp:setProperty name="qt" 
       property="mailPagePath" value="<%= mailPath%>"/>
  <jsp:setProperty name="qt" 
       property="queryPagePath" value="<%= queryPath%>"/>
  <jsp:setProperty name="qt" 
       property="sessionLang" value="<%= sessLang %>"/>
  <jsp:setProperty name="qt"
       property="pageCharset" value="<%= pcharset %>" />
</jsp:useBean>
<%
  long startTime = System.currentTimeMillis();

  if (checkVersion)
  {
    try 
    {
      hasCompatibleVersion = qt.isVersionCompatible();
      if (hasCompatibleVersion)
	checkVersion = false; // don't check again;
    } 
    catch (SQLException sqle) 
    {
      hasCompatibleVersion = false;
      switch (sqle.getErrorCode()) 
      {
      case 1017:
        // cannot login
        hasSession = false;
	break;
      case 6510:
        // hack for instance missing
      case 20000:
        // failed to use instance
        hasInstance = false;
        break;
      default:
	// dump other errors;
	throw sqle;
      }
    }
  }

  String query = qt.getParameter(request, "p_Query");
  String action = qt.getParameter(request, "p_Action");
  String[] attrId = qt.getParameterValues(request, "p_AttrID");
  String[] attrQ  = qt.getParameterValues(request, "p_AttrQ");
  String[] attrOp = qt.getParameterValues(request, "p_AttrOp");
  QueryAttribute[] qattr = null;
  String[] group = qt.getParameterValues(request, "p_Group");
  String language = qt.getParameter(request, "p_Language");
  String pageNo = qt.getParameter(request, "p_Page");
  String hitCount = qt.getParameter(request, "p_Hitcount");
  String advanced = qt.getParameter(request, "p_Advanced");
  String clearCache = qt.getParameter(request, "p_Clear");
  Item[] attrChoices = null;
  Item[] langChoices = null;
  Item[] groupChoices = null;
 
  String resultTable = null;
  String pageLinks = null;

  // this is the basic search if the advanced search is not choosen
  // and there is neither attribute nor group selected
  boolean isAdvanced = (advanced != null || attrId != null ||
                        group != null || language != null);

  // clear cached data?
  if (clearCache != null)
  {
    cachedAttrChoices = null;
    cachedLangChoices = null;
    cachedGroupChoices = null;
  }

%>
<!-- Component : HEAD -->
<HTML>
<HEAD>
  <TITLE> Oncology over Internet </TITLE>
  <LINK href="<%= cssPath %>" rel="stylesheet" type="text/css">
</HEAD>
<BODY bgcolor=lightgoldenrodyellow background="<%= imagePath %>/wsd.gif">
<!-- Component : Top banner -->
<CENTER>
<TABLE width="100%" border="0" cellpadding=2 cellspacing=0>
<TR>
  <TD width="1%" align="left">
    <IMG src="<%= imagePath %>/ultra_mediumbanner.gif">
  </TD>
  <TD align="right" nowrap>
<%
  if (isAdvanced)
  {
%>
[<FONT CLASS="mainfont">
<A href="<%= queryPath %>">Basic Search</a>
</FONT>]
<%
  }
  else
  {
%>
[<FONT CLASS="mainfont">
<A href="<%= queryPath %>?p_Advanced=1">Advanced Search</a>
</FONT>]
<%
  }
%> 
[<FONT CLASS="mainfont">
<A href="<%= helpPath %>">Help</a>
</FONT>] 
[<FONT CLASS="mainfont">
<A href="<%= addURLPath %>">Submit URL</a>
</FONT>]
  </TD>
</TR>
</TABLE>
</CENTER>
<!-- Component : Query input box -->
<%
  if (isAdvanced)
  {
    if (cachedAttrChoices == null)
    {
      cachedAttrChoices = qt.getAttributes();
    }
    if (cachedLangChoices == null)
    {
      cachedLangChoices = qt.getLanguages();
    }
    if (cachedGroupChoices == null)
    {
      cachedGroupChoices = qt.getGroups();
    }
    groupChoices = cachedGroupChoices;
    attrChoices = cachedAttrChoices;
    langChoices = cachedLangChoices;

    // set up attribute query
    if (attrId != null && attrId.length > 0)
    {
      // already in the advanced search
      qattr = new QueryAttribute[attrId.length];
      for (int i = 0; i < attrId.length; i++)
      {
        qattr[i] = new QueryAttribute(attrId[i], attrQ[i], attrOp[i]);
      }
    }
    else
    {
      // first time in the advanced search,
      // initially 4 input boxes in the query page
      qattr = new QueryAttribute[4];
      for (int i = 0; i < attrChoices.length && i < 4; i++)
      {
        qattr[i] = new QueryAttribute(attrChoices[i].getId(), null, null);
      }
    }
  }
%>
<%
    if (hasSession && hasInstance && hasCompatibleVersion) {
%>
<%= qt.createQueryForm(action, query, qattr, language, group,
                       attrChoices, langChoices, groupChoices, null, null) %>
<%
    }else{
    if (!hasSession)
       out.println("<table><tr><td align=left><b><br>Logon denied:</td></tr><tr><td align=left><b><BR>Invalid username/password</td></tr></table>");
    else if (!hasInstance)
       out.println("<table><tr><td align=left><b><br>Oracle Ultra Search error:</td></tr><tr><td align=left><b><BR>Instance does not exist</td></tr></table>");
    else if (!hasCompatibleVersion) {
       out.println("<table><tr><td align=left><b><br>Incompatible versions:</td></tr><tr><td align=left><b><BR>PL/SQL Package Version: "+QueryTool.getPlsqlVersion()+"</td></tr>");
       out.println("<tr><td align=left><b>Ultra Search Query Tool Version: "+QueryTool.getQueryVersion()+"</td></tr></table>");
    }
  }
%>
<P>
<!-- Component : Search result -->
<%
  if (action != null && action.equals(qt.getSearchButton()))
  {
    Item[] groups;
    if (group != null)
    {
      groups = new Item[group.length];
      for (int i=0; i<group.length; i ++)
        groups[i] = new Item(group[i],"");
    }
    else
    {
      groups = null;
    }
    int intPageNo = (pageNo == null ? 1 : Integer.parseInt(pageNo));
    resultTable = qt.createResultTable(query, intPageNo,
                                       qattr, groups, language);


    // Get Hit count
    int intHitsPerPage = qt.getHitsPerPage();
    int intHitCount = 0;
    int start;
    int end;

    if (hitCount == null)
    {
      intHitCount = qt.estimateHitCount(query, qattr, groups, language);
    }
    else
    {
      intHitCount = Integer.parseInt(hitCount);
    }
    start = (intPageNo - 1) * intHitsPerPage + 1;
    end = intPageNo * intHitsPerPage;
    if (intHitCount < end) end = intHitCount;

    // Search link table
    if (intHitCount > 0)
    {
      pageLinks = qt.createPageLinks(query, intPageNo, intHitCount,
                                     qattr, groups, language, null);
    }
%>

<CENTER>
<TABLE width=100% cellpadding=0 cellspacing=0 border=0>
<TR>
<TD bgcolor="#333366" align=left valign=top width=1%>
  <IMG src="<%= imagePath %>/roundbl.gif" border=0 width=10 height=16>
</TD>
<TD bgcolor="#333366" align=left>
  <FONT face=arial,helvetica color="#ffffff">
  <B>Risultati ricerca per <%= query %></B></FONT>
</TD>
<TD bgcolor="#333366" align=right valign=top width=1%>
  <IMG src="<%= imagePath %>/roundbr.gif" border=0 width=10 height=16>
</TD>
</TR>
</TABLE>
</CENTER>

<%= resultTable %>

<CENTER><TABLE width=100% border=0 cellpadding=0 cellspacing=0 class="linktable">
<tr class="linkfont"><td bgcolor="#cccccc" align=left>
<font face=times,arial,helvetica size=-1><b>
<%
    if (intHitCount > 0)
    {
%>
&nbsp;Documents  <%= start %> - <%= end %> 
of about <%= intHitCount %> matching the query, best matches first.
<%
      if (pageLinks.length() > 0)
      {
%>
<br>&nbsp;Goto: <%= pageLinks %>
<%
      }
    }
    else
    {
%>
&nbsp;There is no match for the query. 
<%
    }
%>
</b></font>
</td>
<!--
<TD bgcolor="#cccccc" align=right valign=top nowrap>
<font face=times,arial,helvetica size=-1>
  took <%= (System.currentTimeMillis() - startTime) / 1000.0f %> 
seconds.</FONT>
</TD>
-->
</tr>
</table></center>
<%
  }
%>
</CENTER>
</BODY>
</HTML>
