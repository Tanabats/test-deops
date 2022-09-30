// Import express
let express = require('express');
// Import Body parser
let bodyParser = require('body-parser');
// Import Mongoose
let mongoose = require('mongoose');
// Initialise the app
let app = express();
var cors = require('cors')
app.use(cors())
let apiRoutes = require("./api-routes");
app.use(bodyParser.urlencoded({
    extended: true
}));
app.use(bodyParser.json());
mongoose.connect('mongodb://10.184.9.116:27017/cicd', { useNewUrlParser: true});
var db = mongoose.connection;

if(!db)
    console.log("Error connecting db")
else
    console.log("Db connected successfully")

var port = process.env.PORT || 8090;

app.get('/alive', (req, res) => res.send('alive'));

app.use('/api', apiRoutes);
app.listen(port, function () {
    console.log("Running on port " + port);
});