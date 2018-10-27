import './main.css';
const {Elm} = require('./Main');
import registerServiceWorker from './registerServiceWorker';
import {Subject} from "rxjs";

export class ElmOut {

    static subject = new Subject();

    static emit(value) {
        this.subject.next(value);
    }

    static stream() {
        return this.subject.asObservable();
    }
}

export class ElmIn {

    static subject = new Subject();

    static emit(value) {
        this.subject.next(value);
    }

    static stream() {
        return this.subject.asObservable();
    }
}

import('./gol.js');

const app = Elm.Main.init({});

app.ports.toGol.subscribe(
    msg => {
        ElmOut.emit(msg)
    }
);

ElmIn.stream().subscribe(
    msg => {
        console.log("sending: " + msg);
        app.ports.fromGol.send(msg)
    }
);

registerServiceWorker();
