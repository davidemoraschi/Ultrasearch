package _ultrasearch._query._9i_25_20_28_copy_29_;

import oracle.jsp.runtime.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.io.*;
import java.util.*;
import java.lang.reflect.*;
import java.beans.*;
import javax.servlet.ServletConfig;
import java.sql.SQLException;
import oracle.context.isearch.query.QueryTool;
import oracle.context.isearch.query.Item;
import oracle.context.isearch.query.QueryAttribute;
import oracle.context.isearch.query.DatabaseConnectionManager;


public class _gsearch extends oracle.jsp.runtime.HttpJsp {

  public final String _globalsClassName = null;

  // ** Begin Declarations



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



  // ** End Declarations

  public void _jspService(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

    response.setContentType( "text/html; charset=iso-8859-1");
    /* set up the intrinsic variables using the pageContext goober:
    ** session = HttpSession
    ** application = ServletContext
    ** out = JspWriter
    ** page = this
    ** config = ServletConfig
    ** all session/app beans declared in globals.jsa
    */
    JspFactory factory = JspFactory.getDefaultFactory();
    PageContext pageContext = factory.getPageContext( this, request, response, null, false, JspWriter.DEFAULT_BUFFER, true);
    // Note: session is false, so no session variable is defined.
    if (pageContext.getAttribute(OracleJspRuntime.JSP_REQUEST_REDIRECTED, PageContext.REQUEST_SCOPE) != null) {
      pageContext.setAttribute(OracleJspRuntime.JSP_PAGE_DONTNOTIFY, "true", PageContext.PAGE_SCOPE);
      factory.releasePageContext(pageContext);
      return;
}
    ServletContext application = pageContext.getServletContext();
    JspWriter out = pageContext.getOut();
    _gsearch page = this;
    ServletConfig config = pageContext.getServletConfig();

    try {
      // global beans
      // end global beans


      out.print(__jsp_StaticText.text[0]);
      out.print(__jsp_StaticText.text[1]);
      out.print(__jsp_StaticText.text[2]);
      out.print(__jsp_StaticText.text[3]);
      out.print(__jsp_StaticText.text[4]);
      out.print(__jsp_StaticText.text[5]);
      out.print(__jsp_StaticText.text[6]);
      out.print(__jsp_StaticText.text[7]);
      out.print(__jsp_StaticText.text[8]);
      out.print(__jsp_StaticText.text[9]);
      oracle.context.isearch.query.QueryTool qt;
      if ((qt = (oracle.context.isearch.query.QueryTool) pageContext.getAttribute( "qt", PageContext.APPLICATION_SCOPE)) == null) {
        qt = (oracle.context.isearch.query.QueryTool) new oracle.context.isearch.query.QueryTool();
        pageContext.setAttribute( "qt", qt, PageContext.APPLICATION_SCOPE);
        out.print(__jsp_StaticText.text[10]);
        qt.setUser( OracleJspRuntime.toStr( username));
        out.print(__jsp_StaticText.text[11]);
        qt.setPassword( OracleJspRuntime.toStr( password));
        out.print(__jsp_StaticText.text[12]);
        qt.setResourceFileName( OracleJspRuntime.toStr( propfile));
        out.print(__jsp_StaticText.text[13]);
        qt.setFilePagePath( OracleJspRuntime.toStr( filePath));
        out.print(__jsp_StaticText.text[14]);
        qt.setTablePagePath( OracleJspRuntime.toStr( tablePath));
        out.print(__jsp_StaticText.text[15]);
        qt.setMailPagePath( OracleJspRuntime.toStr( mailPath));
        out.print(__jsp_StaticText.text[16]);
        qt.setQueryPagePath( OracleJspRuntime.toStr( queryPath));
        out.print(__jsp_StaticText.text[17]);
        qt.setSessionLang( OracleJspRuntime.toStr( sessLang));
        out.print(__jsp_StaticText.text[18]);
        qt.setPageCharset( OracleJspRuntime.toStr( pcharset));
        out.print(__jsp_StaticText.text[19]);
      }
      out.print(__jsp_StaticText.text[20]);
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
      
      
      out.print(__jsp_StaticText.text[21]);
      out.print( cssPath );
      out.print(__jsp_StaticText.text[22]);
      out.print( imagePath );
      out.print(__jsp_StaticText.text[23]);
      out.print( imagePath );
      out.print(__jsp_StaticText.text[24]);
              if (isAdvanced)
        {
      
      out.print(__jsp_StaticText.text[25]);
      out.print( queryPath );
      out.print(__jsp_StaticText.text[26]);
              }
        else
        {
      
      out.print(__jsp_StaticText.text[27]);
      out.print( queryPath );
      out.print(__jsp_StaticText.text[28]);
              }
      
      out.print(__jsp_StaticText.text[29]);
      out.print( helpPath );
      out.print(__jsp_StaticText.text[30]);
      out.print( addURLPath );
      out.print(__jsp_StaticText.text[31]);
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
      
      out.print(__jsp_StaticText.text[32]);
                if (hasSession && hasInstance && hasCompatibleVersion) {
      
      out.print(__jsp_StaticText.text[33]);
      out.print( qt.createQueryForm(action, query, qattr, language, group,
                       attrChoices, langChoices, groupChoices, null, null) );
      out.print(__jsp_StaticText.text[34]);
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
      
      out.print(__jsp_StaticText.text[35]);
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
      
      out.print(__jsp_StaticText.text[36]);
      out.print( imagePath );
      out.print(__jsp_StaticText.text[37]);
      out.print( query );
      out.print(__jsp_StaticText.text[38]);
      out.print( imagePath );
      out.print(__jsp_StaticText.text[39]);
      out.print( resultTable );
      out.print(__jsp_StaticText.text[40]);
                if (intHitCount > 0)
          {
      
      out.print(__jsp_StaticText.text[41]);
      out.print( start );
      out.print(__jsp_StaticText.text[42]);
      out.print( end );
      out.print(__jsp_StaticText.text[43]);
      out.print( intHitCount );
      out.print(__jsp_StaticText.text[44]);
                  if (pageLinks.length() > 0)
            {
      
      out.print(__jsp_StaticText.text[45]);
      out.print( pageLinks );
      out.print(__jsp_StaticText.text[46]);
                  }
          }
          else
          {
      
      out.print(__jsp_StaticText.text[47]);
                }
      
      out.print(__jsp_StaticText.text[48]);
      out.print( (System.currentTimeMillis() - startTime) / 1000.0f );
      out.print(__jsp_StaticText.text[49]);
              }
      
      out.print(__jsp_StaticText.text[50]);

      out.flush();

    }
    catch( Exception e) {
      try {
        if (out != null) out.clear();
      }
      catch( Exception clearException) {
      }
      pageContext.handlePageException( e);
    }
    finally {
      if (out != null) out.close();
      factory.releasePageContext(pageContext);
    }

  }
  private static class __jsp_StaticText {
    private static final char text[][]=new char[51][];
    static {
      text[0] = 
      "<!-- **********************************************************************\n globalsearch.jsp is an Oracle Ultra Search Query front end sample. You can\n customize it based on your preference. This sample page is written by\n using JavaServer Pages (JSP) and Oracle Ultra Search Query APIs, so that the\n dynamic part of the page can be separated from the static HTML.\n\n*********************************************************************** -->\n\n\n<!-- JSP page directives -->\n".toCharArray();
      text[1] = 
      "\n".toCharArray();
      text[2] = 
      "\n".toCharArray();
      text[3] = 
      "\n".toCharArray();
      text[4] = 
      "\n".toCharArray();
      text[5] = 
      "\n".toCharArray();
      text[6] = 
      "\n".toCharArray();
      text[7] = 
      "\n".toCharArray();
      text[8] = 
      "\n".toCharArray();
      text[9] = 
      "\n".toCharArray();
      text[10] = 
      "\n  ".toCharArray();
      text[11] = 
      "\n  ".toCharArray();
      text[12] = 
      "\n  ".toCharArray();
      text[13] = 
      "\n  ".toCharArray();
      text[14] = 
      "\n  ".toCharArray();
      text[15] = 
      "\n  ".toCharArray();
      text[16] = 
      "\n  ".toCharArray();
      text[17] = 
      "\n  ".toCharArray();
      text[18] = 
      "\n  ".toCharArray();
      text[19] = 
      "\n".toCharArray();
      text[20] = 
      "\n".toCharArray();
      text[21] = 
      "\n<!-- Component : HEAD -->\n<HTML>\n<HEAD>\n  <TITLE>Oncology over Internet</TITLE>\n  <LINK href=\"".toCharArray();
      text[22] = 
      "\" rel=\"stylesheet\" type=\"text/css\">\n</HEAD>\n<BODY bgcolor=lightgoldenrodyellow background=\"".toCharArray();
      text[23] = 
      "/wsd.gif\">\n<!-- Component : Top banner -->\n<CENTER>\n<TABLE width=\"100%\" border=\"0\" cellpadding=2 cellspacing=0>\n<TR>\n  <TD width=\"1%\" align=\"left\">\n    <IMG src=\"".toCharArray();
      text[24] = 
      "/ultra_mediumbanner.gif\">\n  </TD>\n  <TD align=\"right\" nowrap>\n".toCharArray();
      text[25] = 
      "\n[<FONT CLASS=\"mainfont\">\n<A href=\"".toCharArray();
      text[26] = 
      "\">Basic Search</a>\n</FONT>]\n".toCharArray();
      text[27] = 
      "\n[<FONT CLASS=\"mainfont\">\n<A href=\"".toCharArray();
      text[28] = 
      "?p_Advanced=1\">Advanced Search</a>\n</FONT>]\n".toCharArray();
      text[29] = 
      " \n[<FONT CLASS=\"mainfont\">\n<A href=\"".toCharArray();
      text[30] = 
      "\">Help</a>\n</FONT>] \n[<FONT CLASS=\"mainfont\">\n<A href=\"".toCharArray();
      text[31] = 
      "\">Submit URL</a>\n</FONT>]\n  </TD>\n</TR>\n</TABLE>\n</CENTER>\n<!-- Component : Query input box -->\n".toCharArray();
      text[32] = 
      "\n".toCharArray();
      text[33] = 
      "\n".toCharArray();
      text[34] = 
      "\n".toCharArray();
      text[35] = 
      "\n<P>\n<!-- Component : Search result -->\n".toCharArray();
      text[36] = 
      "\n\n<CENTER>\n<TABLE width=100% cellpadding=0 cellspacing=0 border=0>\n<TR>\n<TD bgcolor=\"#333366\" align=left valign=top width=1%>\n  <IMG src=\"".toCharArray();
      text[37] = 
      "/roundbl.gif\" border=0 width=10 height=16>\n</TD>\n<TD bgcolor=\"#333366\" align=left>\n  <FONT face=arial,helvetica color=\"#ffffff\">\n  <B>Risultati ricerca per ".toCharArray();
      text[38] = 
      "</B></FONT>\n</TD>\n<TD bgcolor=\"#333366\" align=right valign=top width=1%>\n  <IMG src=\"".toCharArray();
      text[39] = 
      "/roundbr.gif\" border=0 width=10 height=16>\n</TD>\n</TR>\n</TABLE>\n</CENTER>\n\n".toCharArray();
      text[40] = 
      "\n\n<CENTER><TABLE width=100% border=0 cellpadding=0 cellspacing=0 class=\"linktable\">\n<tr class=\"linkfont\"><td bgcolor=\"#cccccc\" align=left>\n<font face=times,arial,helvetica size=-1><b>\n".toCharArray();
      text[41] = 
      "\n&nbsp;Documents  ".toCharArray();
      text[42] = 
      " - ".toCharArray();
      text[43] = 
      " \nof about ".toCharArray();
      text[44] = 
      " matching the query, best matches first.\n".toCharArray();
      text[45] = 
      "\n<br>&nbsp;Goto: ".toCharArray();
      text[46] = 
      "\n".toCharArray();
      text[47] = 
      "\n&nbsp;There is no match for the query. \n".toCharArray();
      text[48] = 
      "\n</b></font>\n</td>\n<!--\n<TD bgcolor=\"#cccccc\" align=right valign=top nowrap>\n<font face=times,arial,helvetica size=-1>\n  took ".toCharArray();
      text[49] = 
      " \nseconds.</FONT>\n</TD>\n-->\n</tr>\n</table></center>\n".toCharArray();
      text[50] = 
      "\n</CENTER>\n</BODY>\n</HTML>\n".toCharArray();
    }
  }
}
