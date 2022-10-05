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
var connection = "mongodb://root:kL9xrriy3L@my-release-mongodb-headless.mongodb:27017"
console.log(connection)
mongoose.connect(connection, { useNewUrlParser: true});
var db = mongoose.connection;

if(!db)
    console.log("Error connecting db")
else
    console.log("Db connected successfully")

var port = process.env.PORT || 8000;

app.get('/alive', (req, res) => res.send('alive'));
app.get('/', (req, res) => res.send('alive'));

app.use('/api', apiRoutes);

app.listen(port, function () {
    console.log("Running on port " + port);
});