<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page import="com.npc.lottery.common.Constant "%>
<%@ page import="com.npc.lottery.sysmge.entity.ManagerStaff,com.npc.lottery.sysmge.entity.ManagerUser"%>
<%@ page import="com.npc.lottery.user.entity.SubAccountInfo"%>
<%@ taglib prefix="lottery" uri="/WEB-INF/tag/pagination.tld"%><!-- 分页标签 -->
<% ManagerUser userInfo = (ManagerUser) session.getAttribute(Constant.MANAGER_LOGIN_INFO_IN_SESSION); %>
<% 

	   boolean isSys = ManagerStaff.USER_TYPE_SYS.equals(userInfo.getUserType());// 系统類型
       boolean isManager = ManagerStaff.USER_TYPE_MANAGER.equals(userInfo.getUserType());// 總管類型
      boolean isChief = ManagerStaff.USER_TYPE_CHIEF.equals(userInfo.getUserType());// 總监類型
      boolean isBranch = ManagerStaff.USER_TYPE_BRANCH.equals(userInfo.getUserType());// 分公司類型
      boolean isStockholder = ManagerStaff.USER_TYPE_STOCKHOLDER.equals(userInfo.getUserType());// 股東
      boolean isGenAgent = ManagerStaff.USER_TYPE_GEN_AGENT.equals(userInfo.getUserType());// 總代理
      boolean isAgent = ManagerStaff.USER_TYPE_AGENT.equals(userInfo.getUserType());// 代理
      boolean isSub = ManagerStaff.USER_TYPE_SUB.equals(userInfo.getUserType());// 子账号
      
      if(isSub==true){
          if(ManagerStaff.USER_TYPE_CHIEF.equals(userInfo.getParentStaffTypeQry())) isChief=true;
          if(ManagerStaff.USER_TYPE_BRANCH.equals(userInfo.getParentStaffTypeQry())) isBranch=true;
          if(ManagerStaff.USER_TYPE_STOCKHOLDER.equals(userInfo.getParentStaffTypeQry())) isStockholder=true;
          if(ManagerStaff.USER_TYPE_GEN_AGENT.equals(userInfo.getParentStaffTypeQry())) isGenAgent=true;
          if(ManagerStaff.USER_TYPE_AGENT.equals(userInfo.getParentStaffTypeQry())) isAgent=true;
      }
      String rs = request.getParameter("rs"); 
      if(Constant.COMPANY_STATUS.equals(rs)){
    	  isChief = true;
      }
%>
<head>
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/index.css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<div id="content">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td height="30" background="${pageContext.request.contextPath}/images/admin/tab_05.gif"><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="12" height="30"><img src="${pageContext.request.contextPath}/images/admin/tab_03.gif" width="12" height="30" /></td>
        <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="50%" align="left" valign="middle"><table width="27%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="1%"><img src="${pageContext.request.contextPath}/images/admin/tb.gif" width="16" height="16" /></td>
                <td width="99%" align="left" class="F_bold">&nbsp;下注表明細</td>
              </tr>
            </table></td>
            <td align="right" width="50%"><img src="${pageContext.request.contextPath}/images/admin/close.gif" width="10" height="10" /> <a href="#" onClick='window.close()'>关闭</a></td>
            </tr></table></td>
        <td width="16"><img src="${pageContext.request.contextPath}/images/admin/tab_07.gif" width="16" height="30" /></td>
      </tr>
    </table></td>
  </tr>
  <tr>
    <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="8" background="${pageContext.request.contextPath}/images/admin/tab_12.gif">&nbsp;</td>
        <td align="center">
          <table width="100%" border="0" cellspacing="0" cellpadding="0" class="king mt4 ssgd_padding">
            <colgroup>
              <col width="126" />
              <col width="72" />
              <col width="72" />
              <col width="72" />
              <col width="72" />
              <col width="72" />
              <col width="60" />
              <col width="200" />
              <col width="100" />
              </colgroup>
            <tr>
              <th width="14%"><strong>注單號/時間</strong></th>
              <th width="12%"><strong>下注類型</strong></th>
              <th width="8%"><strong>会員</strong></th>
              <th width="10%"><strong>会員下注</strong></th>
              <th width="7%"><strong>会員輸赢</strong></th>
              <th width="13%"><strong>下注明細</strong></th>
              <th width="6%"><strong>代理</strong></th>
               <%if(isChief || isBranch || isStockholder || isGenAgent){%>
              <th width="6%"><strong>總代理</strong></th>
              <%} %>
               <%if(isChief || isBranch || isStockholder){%>
              <th width="6%"><strong>股东</strong></th>
              <%} %>
              <%if(isChief || isBranch){%>
              <th width="5%"><strong>分公司</strong></th>
               <%} %>
              <%if(isChief){%>
              <th width="5%"><strong>總監</strong></th>
              <%} %>
              <th width="8%"><span class="red"><strong>您的占成</strong></span></th>
            </tr>
            <!-- 判断是否存在对应的数据 -->
	        <s:if test="null == #request.page.result || 0 == #request.page.result.size()">
	              <tr bgcolor='#FFFFFF' class=''>
	                  <td align="left" colspan='15'>
	                      <font color='#FF0000'>未查詢到满足条件的数据！</font>
	                  </td>
	              </tr>
	        </s:if><s:else>
	            <!-- 内容开始 -->
	            <s:iterator value="#request.page.result" status="">
		            <tr onmouseover="this.style.backgroundColor='#FFFFA2'" onmouseout="this.style.backgroundColor=''">
		              <td><s:property value="orderNo" escape="false" />#
		                  <span class="blue"><strong><s:property value="whoReplenish" escape="false" /></strong></span><br />
		                <s:property value="bettingDateStr" escape="false"/>
		                <%-- <s:date name="bettingDate" format="MM-dd HH:mm:ss E"/> --%>
		              </td>
		              <td><s:property value="playTypeName" escape="false" /><br />
		                <span class="green"><s:property value="periodsNum" escape="false" />期</span></td>
		              <td><s:property value="userName" escape="false" /><br />
		                <s:property value="plate" escape="false" />盘</td>
		              <td class="t_right"><s:property value="moneyDis" escape="false" /></td>
		              <td class="t_right"><span class="blue">[未结算]</span></td>
		              <td><s:property value="typeCodeNameOdd" escape="false" /></td>
		              <td><strong><s:property value="agentRate" escape="false" />%</strong><br />
		                <s:property value="agentCommissionDisplay" escape="false" /></td>
		                
		           <%if(isChief || isBranch || isStockholder || isGenAgent){%>
		              <td><strong><s:property value="genAgentRate" escape="false" />%</strong><br />
		                <s:property value="genAgentCommissionDisplay" escape="false" /></td>
		           <%} %>     
		           
		           <%if(isChief || isBranch || isStockholder){%>     
		              <td><strong><s:property value="stockRate" escape="false" />%</strong><br />
		                <s:property value="stockCommissionDisplay" escape="false" /></td>
		           <%} %>     
		           
		           <%if(isChief || isBranch){%>     
		              <td><strong><s:property value="branchRate" escape="false" />%</strong><br />
		                <s:property value="branchCommissionDisplay" escape="false" /></td>
		           <%} %> 
		               
		            <%if(isChief){%>    
		              <td><strong><s:property value="chiefRate" escape="false" />%</strong><br />
		                <s:property value="chiefCommissionDisplay" escape="false" /></td>
		            <%} %>  
		              <td class="t_right"><s:property value="rateMoneyDis" escape="false" /></td>
		            
		            </tr>
	            <!-- 内容结束 -->
	          </s:iterator>
          </s:else>
          </table>         </td>
        <td width="8" background="${pageContext.request.contextPath}/images/admin/tab_15.gif">&nbsp;</td>
      </tr>
    </table></td>
  </tr>
  <tr>
    <td height="35" background="${pageContext.request.contextPath}/images/admin/tab_19.gif"><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="12" height="35"><img src="${pageContext.request.contextPath}/images/admin/tab_18.gif" width="12" height="35" /></td>
        <td align="center">
            <lottery:paginate url="${pageContext.request.contextPath}/replenish/replenishDetail.action" 
            param="typeCode=${typeCode}&rs=${rs}" recordType=" 筆注單"/>
          </td>
	   <td width="16"><img src="${pageContext.request.contextPath}/images/admin/tab_20.gif" width="16" height="35" /></td>
      </tr>
    </table></td>
  </tr>
</table>
</div>
</body>
</html>