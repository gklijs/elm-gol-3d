import {Universe, Utils} from "game-of-life-3d";
import {ElmIn, ElmOut} from "./index";
import {Subject, timer} from "rxjs";
import {debounceTime} from "rxjs/operators";


let height = 5;
let width = 5;
let depth = 5;
let universe = null;

const init = () =>{
    universe = Universe.new(height, width, depth);
    universe.randomize();
    ElmIn.emit({cells: Utils.getCellsAsBool(universe)});
};

init();
const recreateTrigger = new Subject();

recreateTrigger
    .pipe(debounceTime(300))
    .subscribe(
        _ => init()
    );

const source = timer(500, 1000);
source.subscribe(
    msg => {
        universe.tick();
        const changes = Utils.getChanges(universe);
        ElmIn.emit({births: Array.from(changes[0]), deaths: Array.from(changes[1]), ticks: universe.ticks()});
    }
);

ElmOut.stream().subscribe(
    msg => {
        if(msg.hasOwnProperty('height')){
            height = msg.height;
            recreateTrigger.next(true);
        }else if (msg.hasOwnProperty('width')){
            width = msg.width;
            recreateTrigger.next(true);
        }else if(msg.hasOwnProperty('depth')){
            depth = msg.depth;
            recreateTrigger.next(true);
        }else{
            alert("Unknown  message from Elm: " + msg)
        }
    }
);