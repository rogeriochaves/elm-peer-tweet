'use strict';

import './Stylesheets/Main.scss';
import Elm from './Main';
import { initialData } from './Api/Account';

let App = Elm.embed(Elm.Main, document.getElementById('main'), { data: initialData() });
