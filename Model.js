var mongoose = require('mongoose');
// Setup schema
var dataSchema = mongoose.Schema({
    name: {
        type: String,
        required: true
    },
    age: {
        type: Number,
    },
    create_date: {
        type: Date,
        default: Date.now
    }
});
module.exports = mongoose.model("test", dataSchema,'test')

// var Pipeline = module.exports = mongoose.model('gitlab-ci', pipelineSchema);
// module.exports.get = function (callback, limit) {
//     Pipeline.find(callback).limit(limit);
// }