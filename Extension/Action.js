var Action = function() {};

Action.prototype = {
// called before extension is run
run: function(parameters) {
    parameters.completionFunction({"URL": document.URL, "title": document.title });
},
// called after extension is run
finalize: function(parameters) {
    // program executed in Safari using eval()
    var customJavaScript = parameters["customJavaScript"]
    eval(customJavaScript)
}

};

var ExtensionPreprocessingJS = new Action
