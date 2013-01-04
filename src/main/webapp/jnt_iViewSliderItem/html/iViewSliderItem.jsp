<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>



<c:if test="${not renderContext.editMode}">
    <div
            data-iview:image="${url.files}${currentNode.properties['image'].node.path}"
            <c:if test="${not empty currentNode.properties.transition}"> data-iview:transition="<c:forEach items="${currentNode.properties['transition']}" var="transition">${transition.string},</c:forEach>"</c:if>
            <c:if test="${not empty currentNode.properties.pauseTime}">  data-iview:pausetime="${currentNode.properties.pauseTime.long}"</c:if>
            >
        <c:forEach items="${currentNode.nodes}" var="items">
            <template:module node="${items}" />
        </c:forEach>
        <img src="${url.files}${currentNode.properties['image'].node.path}" style="display:none;"/>
    </div>
</c:if>

<c:if test="${renderContext.editMode}">
    <div style="background-color:#b0b0b0" >
    <img src="${url.files}${currentNode.properties['image'].node.path}" width="700"/><br />
        Transition:
        <c:forEach items="${currentNode.properties['transition']}" var="transition">${transition.string},</c:forEach><br />
        <c:forEach items="${currentNode.nodes}" var="items">
            <template:module node="${items}" />
            <hr />
        </c:forEach>
    </div>
    <template:module path="*" nodeTypes="jnt:iViewSliderCaption"/>
</c:if>

