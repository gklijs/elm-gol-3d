import {Universe, Utils} from "game-of-life-3d";
import {ElmIn, ElmOut} from "./index";

const universe = Universe.new(5, 5, 5);
universe.randomize();

console.log("something");

ElmOut.stream().subscribe(
    msg => {
        console.log(msg);
        universe.tick();
        ElmIn.emit({height: universe.height()});
        ElmIn.emit({width: universe.width()});
        ElmIn.emit({tick: universe.ticks(), bla: "welkom"});
        ElmIn.emit({depth: universe.depth()});
    }
);