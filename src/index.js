'use strict';

import './Stylesheets/Main.scss';
import Elm from './Main';
import { initialAccount } from './Api/Account';
import { setup } from './Ports';

const account = initialAccount();
const path = window.location.hash || "#/";

const initialPorts =
  { path: path
  , accountStream: account
  , publishHeadStream: null
  , publishTweetStream: null
  , publishFollowBlockStream: null
  , downloadHeadStream: null
  , downloadTweetStream: null
  , downloadFollowBlockStream: null
  };

const App = Elm.embed(Elm.Main, document.getElementById('main'), initialPorts);

setup(App.ports);
