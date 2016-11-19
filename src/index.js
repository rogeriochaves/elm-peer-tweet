'use strict';

import 'materialize-css/bin/materialize.css';
import 'materialize-css/bin/materialize.js';
import './Stylesheets/Main.scss';
import Elm from './Main';
import { hash } from './Api/Account';
import { setup } from './Ports';
import { getLocalStorage, openLinksInBrowser } from './Utils/Utils.js';

const accounts = getLocalStorage().accounts;

const initialPorts =
  { userHash: hash()
  , accounts: accounts ? JSON.parse(accounts) : null
  };

const App = Elm.Main.embed(document.getElementById('main'), initialPorts);

setup(App.ports);

openLinksInBrowser();
