var Action = function() {};

Action.prototype = {
// called before extension is run
run: function(parameters) {
    parameters.completionFunction({"URL": document.URL, "title": document.title });
},
// called after extension is run
finalize: function(parameters) {

}

};

var ExtensionPreprocessingJS = new Action
