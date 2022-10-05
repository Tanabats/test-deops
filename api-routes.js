
let router = require('express').Router();

var Controller = require('./Controller');
// Contact routes


router.route('/get')
    .get(Controller.viewall)
router.route('/add')
    .post(Controller.insert)

// Export API routes
module.exports = router;