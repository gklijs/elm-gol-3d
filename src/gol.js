import {Universe, Utils} from "game-of-life-3d";
import {ElmIn, ElmOut} from "./index";

const universe = Universe.new(5, 5, 5);
universe.randomize();

console.log("something");

ElmOut.stream().subscribe(
    msg => {
        universe.tick();
        ElmIn.emit(Utils.getChanges(universe));
    }
);