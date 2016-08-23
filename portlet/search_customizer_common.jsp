<%--
/* $Header: search_customizer_common.jsp 25-feb-2002.17:19:38 wechin Exp $ */

/* Copyright (c) 2000, 2002, Oracle Corporation.  All rights reserved.  */

/*
   DESCRIPTION
     The common file shared by both search_customizer.jsp 
     and portlet/search_edit_defaults.jsp.
   
     The code is essentially the same whether it is used
     for the edit defaults mode support or customizer support.
     
     Note however that the JPDK framework stores edit default
     persistent values separately from customizer values.
     
     Hence, even though the same code is used, the data sets
     are separate between edit defaults and customizer modes.

   Release Version 
     9.0.2

   NOTES
     None

   MODIFIED    (MM/DD/YY)
   wechi 02/25/02 - 
   echee 02/08/02 -
   echee 02/07/02 - Make l_qinst a application scoped bean
   echee 02/01/02 - Fix bug 2209199
   echee 12/05/01 - Commenting for 9.0.2 release
*/
--%><%@ page import="oracle.portal.provider.v2.*" %>
<%@ page import="oracle.portal.provider.v2.http.*" %>
<%@ page import="oracle.portal.provider.v2.render.*" %>
<%@ page import="oracle.portal.provider.v2.render.http.*" %>
<%@ page import="oracle.ultrasearch.query.*" %>
<%@ page import="oracle.ultrasearch.query.app.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.math.*" %>
<%@page import = "oracle.jdbc.pool.OracleDataSource" %>
<%@page import = "oracle.jdbc.pool.OracleConnectionPoolDataSource" %>
<%@page import = "oracle.sql.ArrayDescriptor" %>
<%@page import = "oracle.sql.ARRAY" %>
<%@page import = "oracle.sql.STRUCT" %>
<%@page import = "oracle.sql.Datum" %>
<%@ page session="false" %>

<jsp:useBean id="usearch_queryInstance" class="oracle.ultrasearch.query.QueryInstance" scope="application"></jsp:useBean>
<jsp:useBean id="usearch_resBunHash" class="java.util.Hashtable" scope="application"></jsp:useBean>
<jsp:useBean id="usearch_randomGenerator" class="java.util.Random" scope="application"></jsp:useBean>

<%
   // Get a reference to the portlet render request object
  PortletRenderRequest portletRequest = (PortletRenderRequest)
      request.getAttribute(HttpCommonConstants.PORTLET_RENDER_REQUEST);
%>
<%@ include file="common_global_code.jsp" %>
<%@ include file="portlet_global_code.jsp" %>
<%@ include file="common_init.jsp" %>
<%

  // Override the parameter encoding to UTF8
  s_parameterEncoding = "UTF8";

  // Get the request used by the portlet
  l_request_locale = getLocaleToUseByPortlets(portletRequest);
%>
<%@ include file="../common_customize_instance.jsp" %>
<%@ include file="common_querytool_init.jsp" %>

<%
  // Get the portal page URL
  l_querypath = HttpPortletRendererUtil.htmlFormActionLink
    (request, PortletRendererUtil.PAGE_LINK);

  // Calculate the url to the portal host
  l_portalurl = l_querypath.substring(0, l_querypath.indexOf('/', 7));

  // Derive the images directory on the portal server
  l_images_dir = l_portalurl + "/../images";

  // Define the gif file name of the horizontal line that is 
  // used to separate customizer sections
  String l_graphical_hr_gif = l_images_dir + "/beigepx.gif";

  // The style class for errors
  String l_error_class = PortletRenderer.PORTLET_SUBHEADER_COLOR;

  // Placeholder for error messages
  String l_error_mesg = null;

  // The customizer section title font
  l_font_title = "OraHeaderSub";

  // The customizer prompt font
  String l_font_prompt = "OraInstructionText";
  l_font_main = "OraFieldText";

  // This page both displays the customization form and processes it.
  // We display the form if there isn't a submitted title parameter,
  // else we apply the changes 

  // Get the action
  action = requestGetParameter(request, "action");

  // Get the customized title
  String title = requestGetParameter(request, "usearch.title");

  // Get the customized hits per view
  String hitsperview = requestGetParameter(request, "usearch.hitsperview");

  // Get the customized default search mode
  String mode = requestGetParameter(request, "usearch.mode");

  // Reference to the search portlet customizer object
  SearchPortletCustomizer data = null;

  // If no data groups were selected for preselection, then
  // initialize the selectedGroups array to an empty string array
  if (selectedGroups == null) selectedGroups = new String[0];

  // Get the customized choice whether to hide search results
  String hidesearchresults = requestGetParameter(request, "usearch.hidesearchresults");
  if (hidesearchresults == null) hidesearchresults = "unchecked";

  // Get the customized choice whether to hide the search box
  String hidesearchbox = requestGetParameter(request, "usearch.hidesearchbox");
  if (hidesearchbox == null) hidesearchbox = "unchecked";

  // Get the customized choice whether to hide data groups
  String hidedatagroups = requestGetParameter(request, "usearch.hidedatagroups");
  if (hidedatagroups == null) hidedatagroups = "unchecked";

  // Get the customized choice whether to preselect data groups for searching
  String preselectdatagroups = requestGetParameter(request, "usearch.preselectdatagroups");
  if (preselectdatagroups == null) preselectdatagroups = "unchecked";

  // Get the customized choice whether to hide the attribute constraints section
  String hideattributes = requestGetParameter(request, "usearch.hideattributes");
  if (hideattributes == null) hideattributes = "unchecked";

  // Flag indicating whether this request originated from the 
  // customizer page in the first place
  boolean l_in_customizer = false;
  String incustomizer = requestGetParameter(request, "usearch.incustomizer");
  if (incustomizer!=null && incustomizer.equals("true")) 
  {
    l_in_customizer = true;
  }

  //---------------------------------------------------------
  // Cancel automatically redirects to the page 
  // so will only receive 'OK' or 'APPLY'
  // The following section saves new customization data
  // to the file system.
  //---------------------------------------------------------

  String l_qbox_checked = null;

  if ((action != null) || (l_in_customizer))  
  {
    if (action == null) action = denullify(action);

    // Obtain a reference to the customizer data store
    data = (SearchPortletCustomizer) PortletRendererUtil.getEditData(portletRequest);

    // Set the portlet title
    data.setPortletTitle(title);

    // Set the hits per view value
    if (hitsperview != null)
    {
      // check to make sure that hitsperview is not invalid
      try
      {
        Integer.parseInt(hitsperview);
        data.setHitsPerView(hitsperview);
      }
      catch (Exception nfex)
      {
        l_error_mesg = nfex.getMessage();
        nfex.printStackTrace(System.err);
      }
    }

    // If this is edits default mode, set various parameters
    // such as various sections to hide and preselected 
    // data groups
    if (l_is_edit_defaults)
    {
      if (hidesearchresults != null)
      {
        data.setHideSearchResults(hidesearchresults);
      }
      if (hidesearchbox != null)
      {
        data.setHideSearchBox(hidesearchbox);
      }
      if (hidedatagroups != null)
      {
        data.setHideDataGroupsSection(hidedatagroups);
      }
      if (hideattributes != null)
      {
        data.setHideAttributesSection(hideattributes);
      }
      if (preselectdatagroups != null)
      {
        data.setPreselectDataGroups(preselectdatagroups);
      }
      data.setPreselectedDataGroups(selectedGroups);
      if (mode != null)
      {
        data.setMode(mode);
      } else {
        data.setMode("Basic");
      }
    }

    // Attempt to write the data to the file system.
    try 
    {
      PortletRendererUtil.submitEditData(portletRequest, data);
    }
    catch (Exception submitException)
    {
      submitException.printStackTrace(System.err);
      l_error_mesg = submitException.getMessage();
    }

    // If the user clicked on "OK", then we redirect to 
    // back to to the portlet. If the user clicked on "APPLY"
    // then redisplay this customizer
    if (action.equalsIgnoreCase("OK"))
    {
      response.sendRedirect(portletRequest.getRenderContext().getBackURL());
      return;
    }
    else if (action.equalsIgnoreCase("APPLY")) 
    {
      response.sendRedirect(portletRequest.getRenderContext().getPageURL());
      return;
    }
  }

  // Whether or not we've written information, 
  // we have to read what's stored in the data store.
  try 
  {
    // otherwise just render the form
    data = (SearchPortletCustomizer) PortletRendererUtil.getEditData(portletRequest);
    title = data.getPortletTitle();
    hitsperview = data.getHitsPerView();
    if (l_is_edit_defaults)
    {
      hidesearchresults = data.getHideSearchResults();
      hidesearchbox = data.getHideSearchBox();
      hidedatagroups = data.getHideDataGroupsSection();
      hideattributes = data.getHideAttributesSection();
      preselectdatagroups = data.getPreselectDataGroups();
      selectedGroups = data.getPreselectedDataGroups();
      mode = data.getMode();
    }
  }
  catch (Exception readValueException)
  {
    l_error_mesg = readValueException.getMessage(); 
    readValueException.printStackTrace(System.err);
  }

  //---------------------------------------------------------
  // Set various useful boolean variables 
  //---------------------------------------------------------

  boolean l_is_advanced_mode = false;
  if (mode != null && mode.equals("Advanced")) 
  {
    l_is_advanced_mode = true;
  }

  boolean l_hide_datagroups_bool = false;
  if (hidedatagroups != null && hidedatagroups.equals("checked"))
  {
    l_hide_datagroups_bool = true;
  } 
 
  boolean l_hide_attributes_bool = false;
  if (hideattributes != null && (!hideattributes.equals("checked")))
  {
    l_hide_attributes_bool = true;
  } 

%>
<% PortletRendererUtil.renderCustomizeFormHeader(portletRequest, out, null, "action", null, null); %>
<font class="<%=l_font_main%>">
<br>
<br>
<input type="hidden" name="usearch.incustomizer" value="true">
<table border="0">
<%
  //---------------------------------------------------------
  // Search Portlet Display Name
  //---------------------------------------------------------
%>
  <tr valign="middle">
    <td colspan="2">
      <font class="<%=l_font_title%>">
        <nobr><%=htmlEncode(getMessage(l_resBun, "PORTLET_TITLE"))%></nobr>
      </font>
      <img src="<%=l_graphical_hr_gif%>" border="0" height="1" width="100%"><br>
    </td>
  </tr>
  <tr valign="middle">
    <td nowrap colspan="2">
      <font class="<%=l_font_prompt%>">
        <%=htmlEncode(getMessage(l_resBun, "PORTLET_TITLE_PROMPT"))%>
      </font>
    </td>
  </tr>
  <tr valign="middle">  
    <td colspan="2">
    <blockquote>
      <font class="<%=l_font_main%>">
        <%=htmlEncode(getMessage(l_resBun, "DISPLAY_NAME"))%>:&nbsp;<INPUT TYPE="text"  maxlength="40" size="30" NAME="usearch.title" VALUE="<%= title %>"/>
      </font>
    </blockquote>
    </td>
  </tr>

<%
  if (l_is_edit_defaults)
  {
    //---------------------------------------------------------
    // Select Search Type
    //---------------------------------------------------------
%>
  <tr valign="middle">
    <td colspan="2">
      <font class="<%=l_font_title%>">
        <nobr><%=htmlEncode(getMessage(l_resBun, "SELECT_SEARCH_TYPE"))%></nobr>
      </font>
      <img src="<%=l_graphical_hr_gif%>" border="0" height="1" width="100%"><br>
    </td>
  </tr>
  <tr valign="middle">
    <td colspan="2">
      <font class="<%=l_font_prompt%>">
        <%=htmlEncode(getMessage(l_resBun, "SELECT_SEARCH_TYPE_PROMPT"))%>
      </font>
    </td>
  </tr>
  <tr valign="middle">
    <%
      String l_mode_basic_checked = "";
      String l_mode_advanced_checked = "";
      if (mode != null && mode.equals("Advanced"))
      {
        l_mode_advanced_checked = "checked";
      }
      else 
      {
        l_mode_basic_checked = "checked";
      }
    %>
    <td colspan="2">
    <blockquote>
      <font class="<%=l_font_main%>">
        <INPUT TYPE="radio" onClick="form.submit();" <%=l_mode_basic_checked%> NAME="usearch.mode" VALUE="Basic"/><%=htmlEncode(getMessage(l_resBun, "BASIC_SEARCH"))%>
        <INPUT TYPE="radio" onClick="form.submit();" <%=l_mode_advanced_checked%> NAME="usearch.mode" VALUE="Advanced"/><%=htmlEncode(getMessage(l_resBun, "ADVANCED_SEARCH"))%>
      </font>
    </blockquote>
    </td>
  </tr>

<%
  }
  if (l_is_edit_defaults)
  {
    //---------------------------------------------------------
    // Advanced Search Settings section
    //---------------------------------------------------------

    String l_hidedatagroups_checked = "";
    if (hidedatagroups != null && hidedatagroups.equals("checked"))
    {
      l_hidedatagroups_checked = "checked";
    }
    String l_preselectdatagroups_checked = "";
    if (preselectdatagroups != null && preselectdatagroups.equals("checked"))
    {
      l_preselectdatagroups_checked = "checked";
    }
    String l_hideattributes_checked = "";
    if (hideattributes != null && hideattributes.equals("checked"))
    {
      l_hideattributes_checked = "checked";
    }
    if (l_is_advanced_mode)
    {
%>
    <tr valign="middle">
      <td colspan="2">
        <font class="<%=l_font_title%>">
          <nobr><%=htmlEncode(getMessage(l_resBun, "ADVANCED_SEARCH_SETTINGS"))%></nobr>
        </font>
        <img src="<%=l_graphical_hr_gif%>" border="0" height="1" width="100%"><br>
      </td>
    </tr>
    <tr valign="middle">
      <td colspan="2">
        <font class="<%=l_font_prompt%>">
          <%=htmlEncode(getMessage(l_resBun, "ADVANCED_SEARCH_SETTINGS_PROMPT"))%>
        </font>
      </td>
    </tr>
    <tr><td colspan="2"><blockquote><table border="0">
    <tr>
      <td width="1%">
        <font class="<%=l_font_main%>">
          <INPUT TYPE="checkbox" <%=l_hideattributes_checked%> NAME="usearch.hideattributes" VALUE="checked"/>        
        </font>
      </td>
      <td>
        <font class="<%=l_font_main%>">
          <%=htmlEncode(getMessage(l_resBun, "HIDE_ATTRIBUTE_SECTION"))%>
        </font>
      </td>
    </tr>
    <tr>
      <td width="1%">
        <font class="<%=l_font_main%>">
          <INPUT TYPE="checkbox" onClick="form.submit();" <%=l_hidedatagroups_checked%> NAME="usearch.hidedatagroups" VALUE="checked"/> 
        </font>
      </td>
      <td>
        <font class="<%=l_font_main%>">
          <%=htmlEncode(getMessage(l_resBun, "HIDE_DATA_GROUP_SECTION"))%>
        </font>
      </td>
    </tr>
<%
      if (l_hide_datagroups_bool)
      {
%>
    <tr>
      <td width="1%">
        &nbsp;
      </td>
      <td>
        <font class="<%=l_font_main%>">
          <INPUT TYPE="checkbox" <%=l_preselectdatagroups_checked%> NAME="usearch.preselectdatagroups" VALUE="checked"/>        
        </font>
        <font class="<%=l_font_main%>">
          <%=htmlEncode(getMessage(l_resBun, "PRESELECT_DATA_GROUPS"))%>
        </font>
      </td>
    </tr>
    <tr>
      <td width="1%">&nbsp;</td>
      <td align="left" nowrap>
        <font class="<%=l_font_main%>">
<%
          // groupChoices are the actual groups in the database
          // selectedGroups is an array containing all selected groups
          java.util.Collection l_col = l_instmd.getGroups();
          int l_col_size = 0; 
          Group[] groupChoices = null;
          if (l_col != null)
          {
            l_col_size = l_col.size();
            groupChoices = new Group[l_col_size];
            groupChoices = (Group[]) l_col.toArray(groupChoices);
          }
          int ll_groupCount = 0;
          for (int l_gci = 0; l_gci<groupChoices.length; l_gci++)
          {
            ll_groupCount++;
            Group groupChoice = (Group) groupChoices[l_gci];
            String groupId = Integer.toString(groupChoice.getId());
            String groupName = groupChoice.getName();
            l_qbox_checked = "";
            if (selectedGroups != null && selectedGroups.length > 0)
            {
              int j;
              for (j = 0; j < selectedGroups.length; j++)
              {
                if (groupId.equals(selectedGroups[j]))
                {
                  l_qbox_checked = "checked";
                }
              } 
            }
%> 
          &nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE="checkbox" NAME="<%=l_usearch_p_groups%>" value="<%=groupId%>" <%=l_qbox_checked%>><%=htmlEncode(groupName)%>
<%               
            if (ll_groupCount%3 == 0) 
            {
%>
        </font> 
      </td>
    </tr> 
    <tr> 
      <td width="1%">&nbsp;</td>
      <td align="left" nowrap>
        <font CLASS="<%=l_font_main%>"> 
<%
            }
          }
%> 
        </font>
      </td>
    </tr>
<%
      }
%>
    </table></blockquote></td></tr>
<%
    }
    else
    {
%>
      <input type="hidden" name="usearch.hidedatagroups" value="<%=l_hidedatagroups_checked%>">
      <input type="hidden" name="usearch.hideattributes" value="<%=l_hideattributes_checked%>">
<%
    }

    // Draw hidden fields to represent pre-selection of data groups
    // when in advanced mode and when the data group section is hidden
    if ((l_is_advanced_mode && (!l_hide_datagroups_bool)) || (!l_is_advanced_mode))
    {
%>
      <input type="hidden" name="usearch.preselectdatagroups" value="<%=l_preselectdatagroups_checked%>">
<%
      if (selectedGroups != null && selectedGroups.length > 0)
      {
        int j;
        for (j=0; j<selectedGroups.length; j++)
        {
%>
      <input type="hidden" name="<%=l_usearch_p_groups%>" value="<%=selectedGroups[j]%>" checked>
<%
        }
      }
    }
  }

  if (l_is_edit_defaults)
  {
    //---------------------------------------------------------
    // Hide Search Box
    //---------------------------------------------------------
    String l_hidesearchbox_checked = "";
    if (hidesearchbox != null && hidesearchbox.equals("checked"))
    {
      l_hidesearchbox_checked = "checked";
    }
%>
  <tr valign="middle">
    <td colspan="2">
      <font class="<%=l_font_title%>">
        <nobr><%=htmlEncode(getMessage(l_resBun, "HIDE_SEARCHBOX"))%></nobr>
      </font>
      <img src="<%=l_graphical_hr_gif%>" border="0" height="1" width="100%"><br>
    </td>
  </tr>
  <tr>
    <td colspan="2">
      <font class="<%=l_font_prompt%>">
        <%=htmlEncode(getMessage(l_resBun, "HIDE_SEARCHBOX_PROMPT"))%>
      </font>
    </td>
  </tr>
  <tr valign="middle">  
    <td>
    <blockquote><table border="0"><tr>
    <td width="1%">
      <font class="<%=l_font_main%>">
        <INPUT TYPE="checkbox" <%=l_hidesearchbox_checked%> NAME="usearch.hidesearchbox" VALUE="checked"/>
      </font>
    </td>
    <td>
      <font class="<%=l_font_main%>">
        <%=htmlEncode(getMessage(l_resBun, "HIDE_SEARCHBOX"))%>
      </font>
    </td>
    </tr></table></blockquote>
    </td>
  </tr>

<%
  }
  if (l_is_edit_defaults)
  {
    //---------------------------------------------------------
    // Hide Search Results
    //---------------------------------------------------------
%>
  <tr valign="middle">
    <%
      String l_hidesearchresults_checked = "";
      if (hidesearchresults != null && hidesearchresults.equals("checked"))
      {
        l_hidesearchresults_checked = "checked";
      }
    %>
    <td colspan="2">
      <font class="<%=l_font_title%>">
        <nobr><%=htmlEncode(getMessage(l_resBun, "HIDE_SEARCHRESULTS"))%></nobr>
      </font>
      <img src="<%=l_graphical_hr_gif%>" border="0" height="1" width="100%"><br>
    </td>
  <tr>
  </tr>
    <td colspan="2">
      <font class="<%=l_font_prompt%>">
        <%=htmlEncode(getMessage(l_resBun, "HIDE_SEARCHRESULTS_PROMPT"))%>
      </font>
    </td>
  </tr>
  <tr valign="middle">  
    <td>
    <blockquote><table border="0"><tr>
    <td width="1%">
      <font class="<%=l_font_main%>">
        <INPUT TYPE="checkbox" <%=l_hidesearchresults_checked%> NAME="usearch.hidesearchresults" VALUE="checked"/>
      </font>
    </td>
    <td>
      <font class="<%=l_font_main%>">
        <%=htmlEncode(getMessage(l_resBun, "HIDE_SEARCHRESULTS"))%>
      </font>
    </td>
    </tr></table></blockquote>
    </td>
  </tr>

<%
  }

  //---------------------------------------------------------
  // Hits per view
  //---------------------------------------------------------
%>
  <tr valign="middle">
    <td nowrap colspan="2">
      <font class="<%=l_font_title%>">
        <nobr><%=htmlEncode(getMessage(l_resBun, "HITS_PER_VIEW"))%></nobr>
      </font>
      <img src="<%=l_graphical_hr_gif%>" border="0" height="1" width="100%"><br>
    </td>
  </tr>
  <tr valign="middle">
    <td colspan="2">
      <font class="<%=l_font_prompt%>"><%=htmlEncode(getMessage(l_resBun, "HITS_PER_VIEW_PROMPT"))%></font>
    </td>
  </tr>
  <tr valign="middle">  
    <td colspan="2">
    <blockquote>
      <font class="<%=l_font_main%>">
        <%=htmlEncode(getMessage(l_resBun, "HITS_PER_VIEW"))%>:&nbsp;
        <INPUT TYPE="text" SIZE="3" NAME="usearch.hitsperview" VALUE="<%= hitsperview %>"/>
      </font>
    </blockquote>
    </td>
  </tr>

<%
  if (l_error_mesg != null)
  {
    //---------------------------------------------------------
    // If any error occurred, display it at the bottom of screen
    //---------------------------------------------------------
%>
  <tr>
    <td colspan="2" class="<%=l_error_class%>">
      <%=htmlEncode(l_error_mesg)%>
    </td>
  </tr>
<%
  }
%>

</table>
</font>
<% PortletRendererUtil.renderCustomizeFormFooter(portletRequest, out); %>

