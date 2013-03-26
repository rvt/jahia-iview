<%@ page import="org.jahia.services.content.JCRNodeWrapper" %>
<%@ page import="org.jahia.services.content.rules.IViewImageService" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>

<%
    JCRNodeWrapper currentNode = (JCRNodeWrapper) request.getAttribute("currentNode");
    final String iViewImageNodeName = IViewImageService.iViewNodeName(currentNode);
%>

<c:set var="iViewImageNodeName" value="<%=iViewImageNodeName%>"/>

<c:if test="${not renderContext.editMode}">
    <jcr:node path="${currentNode.properties['image']}" var="jahia-iview"/>
    <%-- make div or a tag --%>
    <c:choose>
        <c:when test="${not empty currentNode.properties['link']}">
            <c:url value="${url.base}${currentNode.properties['link'].node.path}.html" var="link" />
            <a class="linkedBanner" href="${link}"
        </c:when>
        <c:otherwise>
            <div
        </c:otherwise>
    </c:choose>
    data-iview:image="${currentNode.properties['image'].node.thumbnailUrls[iViewImageNodeName]}"
    <c:if test="${not empty currentNode.properties.transition}"> data-iview:transition="<c:forEach
            items="${currentNode.properties['transition']}" var="transition">${transition.string},</c:forEach>"</c:if>
    <c:if test="${not empty currentNode.properties.pauseTime}"> data-iview:pausetime="${currentNode.properties.pauseTime.long}"</c:if>
    >
    <c:forEach items="${currentNode.nodes}" var="items">
        <template:module node="${items}"/>
    </c:forEach>
    <img src="${url.files}${currentNode.properties['image'].node.path}" style="display:none;"/>

    <%-- End with div or a tag --%>
    <c:choose>
        <c:when test="${not empty currentNode.properties['link']}">
            </a>
        </c:when>
        <c:otherwise>
            </div>
        </c:otherwise>
    </c:choose>

</c:if>

<c:if test="${renderContext.editMode}">
    <div style="background-color:#b0b0b0">
        <img src="${currentNode.properties['image'].node.thumbnailUrls["thumbnail2"]}"/><br/>
        <c:if test="${not empty currentNode.properties['link']}">
            <strong>Link:</strong> ${currentNode.properties['link'].node.path}.html<br />
        </c:if>
        Transition:
        <c:forEach items="${currentNode.properties['transition']}"
                   var="transition">${transition.string},</c:forEach><br/>
        <c:forEach items="${currentNode.nodes}" var="items">
            <template:module node="${items}"/>
            <hr/>
        </c:forEach>
    </div>
    <template:module path="*" nodeTypes="jnt:iViewSliderCaption"/>
</c:if>

