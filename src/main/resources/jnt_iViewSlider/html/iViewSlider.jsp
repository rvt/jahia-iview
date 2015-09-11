<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<template:addResources type="javascript" resources="jquery.js"/>
<template:addResources type="javascript" resources="raphael-min.js"/>
<template:addResources type="javascript" resources="jquery.easing.js"/>
<template:addResources type="javascript" resources="jquery.fullscreen.js"/>
<template:addResources type="javascript" resources="iview.js"/>

<c:if test="${not renderContext.editMode}">

    <template:addResources type="css" resources="iview.css"/>
    <c:if test="${currentNode.properties.skin.string ne 'none'}">
        <template:addResources type="css" resources="${currentNode.properties.skin.string}/style.css"/>
    </c:if>
    <template:module path="*"/>

    <template:addResources>
        <script>
            $(document).ready(function(){

                $('#iview-${currentNode.UUID}').iView({
                    <c:if test="${not empty currentNode.properties.fx}">fx:"${currentNode.properties.fx.string}",</c:if>
                    <c:if test="${not empty currentNode.properties.easing}">easing:"${currentNode.properties.easing.string}",</c:if>
                    <c:if test="${not empty currentNode.properties.strips}">strips:${currentNode.properties.strips.long},</c:if>
                    <c:if test="${not empty currentNode.properties.blockCols}">blockCols:${currentNode.properties.blockCols.long},</c:if>
                    <c:if test="${not empty currentNode.properties.blockRows}">blockRows:${currentNode.properties.blockRows.long},</c:if>
                    <c:if test="${not empty currentNode.properties.captionSpeed}">captionSpeed:${currentNode.properties.captionSpeed.long},</c:if>
                    <c:if test="${not empty currentNode.properties.captionEasing}">captionEasing:"${currentNode.properties.captionEasing.string}",</c:if>
                    <c:if test="${not empty currentNode.properties.animationSpeed}">animationSpeed:${currentNode.properties.animationSpeed.long},</c:if>
                    <c:if test="${not empty currentNode.properties.pauseTime}">pauseTime:${currentNode.properties.pauseTime.long},</c:if>
                    <c:if test="${not empty currentNode.properties.startSlide}">startSlide:${currentNode.properties.startSlide.long},</c:if>
                    <c:if test="${not empty currentNode.properties.directionNav}">directionNav:${currentNode.properties.directionNav.boolean},</c:if>
                    <c:if test="${not empty currentNode.properties.directionNavHide}">directionNavHide:${currentNode.properties.directionNavHide.boolean},</c:if>
                    <c:if test="${not empty currentNode.properties.directionNavHoverOpacity}">directionNavHoverOpacity:${currentNode.properties.directionNavHoverOpacity.double},</c:if>
                    <c:if test="${not empty currentNode.properties.controlNav}">controlNav:${currentNode.properties.controlNav.boolean},</c:if>
                    <c:if test="${not empty currentNode.properties.controlNavNextPrev}">controlNavNextPrev:${currentNode.properties.controlNavNextPrev.boolean},</c:if>
                    <c:if test="${not empty currentNode.properties.controlNavHoverOpacity}">controlNavHoverOpacity:${currentNode.properties.controlNavHoverOpacity.double},</c:if>
                    <c:if test="${not empty currentNode.properties.controlNavThumbs}">controlNavThumbs:${currentNode.properties.controlNavThumbs.boolean},</c:if>
                    <c:if test="${not empty currentNode.properties.controlNavTooltip}">controlNavTooltip:${currentNode.properties.controlNavTooltip.boolean},</c:if>
                    <c:if test="${not empty currentNode.properties.autoAdvance}">autoAdvance:${currentNode.properties.autoAdvance.boolean},</c:if>
                    <c:if test="${not empty currentNode.properties.keyboardNav}">keyboardNav:${currentNode.properties.keyboardNav.boolean},</c:if>
                    <c:if test="${not empty currentNode.properties.touchNav}">touchNav:${currentNode.properties.touchNav.boolean},</c:if>
                    <c:if test="${not empty currentNode.properties.pauseOnHover}">pauseOnHover:${currentNode.properties.pauseOnHover.boolean},</c:if>
                    <c:if test="${not empty currentNode.properties.keyboardNav}">keyboardNav:${currentNode.properties.keyboardNav.boolean},</c:if>
                    <c:if test="${not empty currentNode.properties.nextLabel}">nextLabel:"${currentNode.properties.nextLabel.string}",</c:if>
                    <c:if test="${not empty currentNode.properties.previousLabel}">previousLabel:"${currentNode.properties.previousLabel.string}",</c:if>
                    <c:if test="${not empty currentNode.properties.playLabel}">playLabel:"${currentNode.properties.playLabel.string}",</c:if>
                    <c:if test="${not empty currentNode.properties.pauseLabel}">pauseLabel:"${currentNode.properties.pauseLabel.string}",</c:if>
                    <c:if test="${not empty currentNode.properties.closeLabel}">closeLabel:"${currentNode.properties.closeLabel.string}",</c:if>
                    <c:if test="${not empty currentNode.properties.randomStart}">randomStart:${currentNode.properties.randomStart.boolean},</c:if>
                    <c:if test="${not empty currentNode.properties.timer}">timer:"${currentNode.properties.timer.string}",</c:if>
                    <c:if test="${not empty currentNode.properties.timerPosition}">timerPosition:"${currentNode.properties.timerPosition.string}",</c:if>
                    <c:if test="${not empty currentNode.properties.timerBg}">timerBg:"${currentNode.properties.timerBg.string}",</c:if>
                    <c:if test="${not empty currentNode.properties.timerColor}">timerColor:"#${currentNode.properties.timerColor.string}",</c:if>
                    <c:if test="${not empty currentNode.properties.timerOpacity}">timerOpacity:${currentNode.properties.timerOpacity.double},</c:if>
                    <c:if test="${not empty currentNode.properties.timerDiameter}">timerDiameter:${currentNode.properties.timerDiameter.long},</c:if>
                    <c:if test="${not empty currentNode.properties.timerPadding}">timerPadding:${currentNode.properties.timerPadding.long},</c:if>
                    <c:if test="${not empty currentNode.properties.timerStroke}">timerStroke:${currentNode.properties.timerStroke.long},</c:if>
                    <c:if test="${not empty currentNode.properties.timerBarStrokeColor}">timerBarStrokeColor:"#${currentNode.properties.timerBarStrokeColor.string}",</c:if>
                    <c:if test="${not empty currentNode.properties.timerBarStrokeStyle}">timerBarStrokeStyle:"${currentNode.properties.timerBarStrokeStyle.string}",</c:if>
                    <c:if test="${not empty currentNode.properties.timerX}">timerX:${currentNode.properties.timerX.long},</c:if>
                    <c:if test="${not empty currentNode.properties.timerY}">timerY:${currentNode.properties.timerY.long},</c:if>
                    <c:if test="${not empty currentNode.properties.tooltipX}">tooltipX:${currentNode.properties.tooltipX.long},</c:if>
                    <c:if test="${not empty currentNode.properties.tooltipY}">tooltipY:${currentNode.properties.tooltipY.long}</c:if>
                });
            });
        </script>

    </template:addResources>

    <template:addResources type="inlinecss">
        <style>
            <c:choose>
                <c:when test="${not empty currentNode.properties.border}">
                    <c:set var="iviewborder" value="${currentNode.properties.border.long}" />
                </c:when>
                <c:otherwise>
                    <c:set var="iviewborder" value="0" />
                </c:otherwise>
            </c:choose>
            .iviewcontainer {
                <c:if test="${not empty currentNode.properties.width}">width:${currentNode.properties.width.long}px;</c:if>
            }
            .iviewid {
                margin: 0;
                padding: ${iviewborder}px;
            }

            #iview-${currentNode.UUID} {
                <c:if test="${not empty currentNode.properties.width}">width:${currentNode.properties.width.long-iviewborder*2}px;</c:if>
                <c:if test="${not empty currentNode.properties.height}">height:${currentNode.properties.height.long-iviewborder*2}px;</c:if>
            }
            #iview-${currentNode.UUID} .iviewSlider {
                <c:if test="${not empty currentNode.properties.width}">width:${currentNode.properties.width.long-iviewborder*2}px;</c:if>
                <c:if test="${not empty currentNode.properties.height}">height:${currentNode.properties.height.long-iviewborder*2}px;</c:if>
            }
        </style>
    </template:addResources>
</c:if>

<template:addResources type="css" resources="iview-jahia.css"/>

<div class="iviewcontainer">
    <div class="iviewid" id="iview-${currentNode.UUID}" <c:if test="${renderContext.editMode}">style="background-color:#a0a0a0" </c:if> >
        <c:forEach items="${currentNode.nodes}" var="items">
            <template:module node="${items}" />
        </c:forEach>
    </div>
</div>

<c:if test="${renderContext.editMode}">
    <c:if test="${currentNode.properties.directionNav!=null && currentNode.properties.controlNav!=null && currentNode.properties.directionNav.boolean && currentNode.properties.controlNav.boolean}">
        <span style="color:red">Warning, directionNav and controlNav cannot be both set to true.</span>
    </c:if>
    <template:module path="*" nodeTypes="jnt:iViewSliderItem"/>
</c:if>
