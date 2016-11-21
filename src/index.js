'use strict';

import 'materialize-css/bin/materialize.css';
import 'materialize-css/bin/materialize.js';
import './Stylesheets/Main.scss';
import Elm from './Main.elm';
import { hash } from './Api/Account.js';
import { setup } from './Ports.js';
import { getLocalStorage, openLinksInBrowser } from './Utils/Utils.js';

const accounts = getLocalStorage().accounts;

const initialPorts =
  { userHash: hash()
  , accounts: accounts ? JSON.parse(accounts) : null
  };

const App = Elm.Main.embed(document.getElementById('main'), initialPorts);

setup(App.ports);

openLinksInBrowser();
