// contactController.js
// Import contact model
Model = require('./Model');


exports.viewall = function (req, res) {
    Model.find({}, function (err, data) {
        if (err)
            res.send(err);
        res.json(
            data
        );
    });
};

exports.insert = function (req, res) {
    let i_name = req.body.name
    let i_age = req.body.name
    var myobj = { name: i_name, age: i_age };
    myobj = new Model({name: i_name, age: i_age})
    myobj.save(function (err, book) {
        if (err) return res.send(err);
        console.log(" saved to collection.");
        res.json(
            myobj
        );
      });
};