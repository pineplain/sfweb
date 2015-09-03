function onMouseWheel(e) {

    e.preventDefault();
    e = e.originalEvent;

    var delta = Math.max(-1, Math.min(1, (e.wheelDelta || -e.detail))) / 50;
    var offsetX = (e.offsetX || e.clientX - $(this).offset().left); // offsetX is not defined in FF
    var offsetY = (e.offsetY || e.clientY - $(this).offset().top); // offsetY is not defined in FF
    var p = offsetToLocalPoint(offsetX, offsetY);
    var newScale = V(paper.viewport).scale().sx + delta; // the current paper scale changed by delta

    if (newScale > 0.4 && newScale < 2) {
        paper.setOrigin(0, 0); // reset the previous viewport translation
        paper.scale(newScale, newScale, p.x, p.y);
    }
}

function offsetToLocalPoint(x, y) {
    var svgPoint = paper.svg.createSVGPoint();
    svgPoint.x = x;
    svgPoint.y = y;
    // Transform point into the viewport coordinate system.
    var pointTransformed = svgPoint.matrixTransform(paper.viewport.getCTM().inverse());
    return pointTransformed;
}
