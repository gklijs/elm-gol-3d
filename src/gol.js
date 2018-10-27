import {Universe, Utils} from "game-of-life-3d";
import {ElmIn, ElmOut} from "./index";

const universe = Universe.new(5, 5, 5);
universe.randomize();

console.log("something");

ElmOut.stream().subscribe(
    msg => {
        universe.tick();
        ElmIn.emit(JSON.stringify({height: universe.height()}));
        ElmIn.emit(JSON.stringify({width: universe.width()}));
        ElmIn.emit(JSON.stringify({tick: universe.ticks(), bla: "welkom"}));
        ElmIn.emit(JSON.stringify({depth: universe.depth()}));
    }
);