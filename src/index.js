'use strict';

require("./Stylesheets/Main.scss");
var Elm = require('./Main');

Elm.embed(Elm.Main, document.getElementById('main'));
