var mongoose = require('mongoose');
// Setup schema
var dataSchema = mongoose.Schema({
    pipeline_id: {
        type: String,
        required: true
    },
    build_no: {
        type: String,
    },
    branch_name: String,
    jira_id: String,
    create_date: {
        type: Date,
        default: Date.now
    }
});
module.exports = mongoose.model("gitlab_ci", dataSchema,'gitlab_ci')

// var Pipeline = module.exports = mongoose.model('gitlab-ci', pipelineSchema);
// module.exports.get = function (callback, limit) {
//     Pipeline.find(callback).limit(limit);
// }