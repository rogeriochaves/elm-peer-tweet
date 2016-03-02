'use strict';

import './Stylesheets/Main.scss';
import Elm from './Main';
import { initialData } from './Api/Account';
import { setup } from './Ports';

const data = initialData();
const initialPorts = { dataStream: data, publishHeadStream: null, publishTweetStream: null }
const App = Elm.embed(Elm.Main, document.getElementById('main'), initialPorts);

setup(App.ports);
