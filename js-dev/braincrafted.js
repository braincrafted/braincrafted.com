window.onload = function() {
    var aCodes = document.getElementsByTagName('code');
    for (var i=0; i < aCodes.length; i++) {
        hljs.highlightBlock(aCodes[i]);
    }
};
