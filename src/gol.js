import {Universe, Utils} from "game-of-life-3d";

const universe = Universe.new(500, 500, 500);
universe.randomize();

console.log("something");

const renderLoop = () => {
    universe.tick();
    console.log(Utils.getChanges(universe));
    requestAnimationFrame(renderLoop);
};

renderLoop();