import './main.css';
const {Elm} = require('./Main');
import registerServiceWorker from './registerServiceWorker';
import('./gol.js');

const app = Elm.Main.init({});

app.ports.logger.subscribe(message => {
    console.log('Port emitted a new message: ' + message);
});

app.ports.tick.subscribe(message => {
    console.log('tick: ' + message);
});

registerServiceWorker();
