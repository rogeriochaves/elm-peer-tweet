'use strict';

import './Stylesheets/Main.scss';
import Elm from './Main';
import { initialAccount } from './Api/Account';
import { setup } from './Ports';

const account = initialAccount();
const initialPorts = { accountStream: account, publishHeadStream: null, publishTweetStream: null, downloadHeadStream: null, downloadTweetStream: null };
const App = Elm.embed(Elm.Main, document.getElementById('main'), initialPorts);

setup(App.ports);
