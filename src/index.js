'use strict';

import './Stylesheets/Main.scss';
import Elm from './Main';
import { initialData } from './Api/Account';
import { setup } from './Ports';

let App = Elm.embed(Elm.Main, document.getElementById('main'), { setData: initialData() });

setup(App.ports);
