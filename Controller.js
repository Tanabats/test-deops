// contactController.js
// Import contact model
Model = require('./Model');



exports.view = function (req, res) {
    input = req.params.pipeline_id
    Model.find({"pipeline_id":input}, function (err, data) {
        if (err)
            res.send(err);
        res.json(
            data
        );
    });
};