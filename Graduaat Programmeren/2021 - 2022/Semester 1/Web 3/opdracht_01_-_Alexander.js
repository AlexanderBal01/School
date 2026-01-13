const arr = [0, 5, 10, 18, 30];

// forEach
arr.forEach(x => console.log(x));

// map
let mapper = arr.map(x => (x*5))
console.log(mapper);

// filter
const groterDan30 = (number) => {
    if (number > 30){
        console.log(number);
    }    
};

mapper.filter(groterDan30);

// reduce
const som = mapper.reduce((acc, value) => {
    return acc + value;
});
console.log(som);

// spread opperator
const arr2 = [54, 68];
const arr3 = [...arr, ...arr2];
console.log(arr3);

let obj = {
    voorNaam: "alexander",
    achterNaam: "Bal",
    leeftijd: 19 
};

let ob2 = {...obj, geboortePlaats: "Dendermonde"};
console.log(ob2);

// Destructuring
const {voorNaam} = obj;
console.log(voorNaam);