'use strict';

import './Stylesheets/Main.scss';
import Elm from './Main';
import { hash } from './Api/Account';
import { setup } from './Ports';

const path = window.location.hash || "#/";

const initialPorts =
  { path: path
  , userHash: hash()
  , accountStream: null
  , publishHeadStream: null
  , publishTweetStream: null
  , publishFollowBlockStream: null
  , downloadHeadStream: [null, null]
  , downloadTweetStream: null
  , downloadFollowBlockStream: null
  };

const App = Elm.embed(Elm.Main, document.getElementById('main'), initialPorts);

setup(App.ports);
