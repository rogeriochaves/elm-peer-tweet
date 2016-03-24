'use strict';

import 'materialize-css/bin/materialize.css';
import 'materialize-css/bin/materialize.js';
import './Stylesheets/Main.scss';
import Elm from './Main';
import { hash } from './Api/Account';
import { setup } from './Ports';
import { getLocalStorage } from './Api/Utils';

const path = window.location.hash || "#/";
const accounts = getLocalStorage().accounts;

const initialPorts =
  { path: path
  , userHash: hash()
  , getStorage: accounts ? JSON.parse(accounts) : null
  , accountStream: null
  , publishHeadStream: null
  , publishTweetStream: null
  , publishFollowBlockStream: null
  , downloadErrorStream: null
  , downloadHeadStream: null
  , downloadTweetStream: null
  , downloadFollowBlockStream: null
  , createdKeysStream: null
  , doneLoginStream: null
  };

const App = Elm.embed(Elm.Main, document.getElementById('main'), initialPorts);

setup(App.ports);
