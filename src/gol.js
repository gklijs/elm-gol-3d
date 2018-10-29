import {Universe, Utils} from "game-of-life-3d";
import {ElmIn, ElmOut} from "./index";
import {timer, merge} from "rxjs";

let height = 5;
let width = 5;
let depth = 5;
const universe = Universe.new(height, width, depth);
universe.randomize();

ElmIn.emit({cells: Utils.getCellsAsBool(universe)});

const source = timer(500, 1000);
const combined = merge(source, ElmOut.stream());

combined.subscribe(
    msg => {
        console.log(msg);
        universe.tick();
        const changes = Utils.getChanges(universe);
        ElmIn.emit({births: Array.from(changes[0]), deaths: Array.from(changes[1]), ticks: universe.ticks()});
    }
);