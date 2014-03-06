<%@ page import="org.jahia.services.content.JCRNodeWrapper" %>
<%@ page import="org.jahia.modules.iview.rules.IViewImageService" %>
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

    <%-- transition valyes --%>
    <c:set var="params" value="data-iview:image=\"${currentNode.properties['image'].node.thumbnailUrls[iViewImageNodeName]}\"" />
    <c:if test="${not empty currentNode.properties.transition}">
        <c:set var="params" value="${params} data-iview:transition=\"" />
        <c:forEach items="${currentNode.properties['transition']}" var="transition">
            <c:set var="params" value="${params} ${transition.string}," />
        </c:forEach>
        <c:set var="params" value="${params}\"" />
    </c:if>

    <c:if test="${not empty currentNode.properties.pauseTime}">
        <c:set var="params" value="${params} data-iview:pausetime=\"${currentNode.properties.pauseTime.long}\"" />
    </c:if>

    <%-- make div or a tag --%>
    <c:choose>
        <c:when test="${not empty currentNode.properties.link || not empty currentNode.properties.externalLink.string}">
            <c:if test="${not empty currentNode.properties.link}">
                <c:choose>
                    <c:when test="${jcr:isNodeType(currentNode.properties.link.node, 'nt:file')}">
                        <c:url value="${url.files}${currentNode.properties.link.node.path}" var="link" />
                    </c:when>
                    <c:otherwise>
                        <c:url value="${url.base}${currentNode.properties.link.node.path}.html" var="link" />
                    </c:otherwise>
                </c:choose>

            </c:if>
            <c:if test="${not empty currentNode.properties.externalLink.string}">
                <c:url value="${currentNode.properties.externalLink.string}" var="link" />
            </c:if>
            <a ${params} class="linkedBanner" href="${link}"<c:if test="${not empty currentNode.properties['j:target']}"> target="${currentNode.properties['j:target'].string}"></c:if>>
        </c:when>
        <c:otherwise>
            <div ${params}>
        </c:otherwise>
    </c:choose>
    <c:forEach items="${currentNode.nodes}" var="items">
        <template:module node="${items}"/>
    </c:forEach>
    <img src="${currentNode.properties['image'].node.thumbnailUrls[iViewImageNodeName]}" style="display:none;"/>

    <%-- End with div or a tag --%>
    <c:choose>
        <c:when test="${not empty currentNode.properties.link || not empty currentNode.properties.externalLink.string}">
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
        <c:if test="${not empty currentNode.properties.link}">
            <strong>Link:</strong> ${currentNode.properties.link.node.path}<br />
        </c:if>
        <c:if test="${not empty currentNode.properties.externalLink.string}">
            <strong>Link:</strong> ${currentNode.properties.externalLink.string}<br />
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

