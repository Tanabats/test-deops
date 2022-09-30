// api-routes.js
// Initialize express router
let router = require('express').Router();
// // Set default API response
// router.get('/', function (req, res) {
//     res.json({
//         status: 'API Its Working',
//         message: 'Welcome to RESTHub crafted with love!',
//     });
// });
// Import contact controller
var Controller = require('./Controller');
// Contact routes

router.route('/pipeline/:pipeline_id')
    .get(Controller.view)

// Export API routes
module.exports = router;