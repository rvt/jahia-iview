<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<c:if test="${not renderContext.editMode}">
    <div class="iview-caption"
            <c:if test="${not empty currentNode.properties.transition}"> data-transition="${currentNode.properties.transition.string}"</c:if>
            <c:if test="${not empty currentNode.properties.easing}"> data-easing="${currentNode.properties.easing.string}"</c:if>
            <c:if test="${not empty currentNode.properties.posX}"> data-x="${currentNode.properties.posX.long}"</c:if>
            <c:if test="${not empty currentNode.properties.posY}"> data-y="${currentNode.properties.posY.long}"</c:if>
            <c:if test="${not empty currentNode.properties.width}"> data-width="${currentNode.properties.width.long}"</c:if>
            <c:if test="${not empty currentNode.properties.height}"> data-height="${currentNode.properties.height.long}"</c:if>
            <c:if test="${not empty currentNode.properties.speed}"> data-speed="${currentNode.properties.speed.long}"</c:if>
    >
        ${currentNode.properties.caption.string}
    </div>
</c:if>

<c:if test="${renderContext.editMode}">
    <div style="background-color:#c0c0c0" >
        Caption: ${currentNode.properties['caption'].string}<br />
        Transition: <strong>${currentNode.properties['transition'].string}</strong> Easing: <strong>${currentNode.properties['easing'].string}</Strong><br />
        Position (X,Y): <strong>${currentNode.properties['posX'].string},${currentNode.properties['posY'].string}</Strong><br />
        Size (Width,Height): <strong>${currentNode.properties['width'].string},${currentNode.properties['height'].string}</Strong>
    </div>
</c:if>
