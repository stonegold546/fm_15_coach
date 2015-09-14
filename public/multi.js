/*jslint browser:true */

function colourMeFunction() {
    "use strict";
    var inputs = document.getElementsByClassName('colour'),
        idx = 0,
        val;
    for (idx; idx < inputs.length; idx += 1) {
        val = parseFloat(inputs[idx].textContent);
        if (val > 4) {
            inputs[idx].style.backgroundColor = '#ff0000';
        } else if (val > 3.5) {
            inputs[idx].style.backgroundColor = '#00ff00';
        } else if (val > 2.5) {
            inputs[idx].style.backgroundColor = '#ffff00';
        }
    }
}

function killColourFunction() {
    "use strict";
    var inputs = document.getElementsByClassName('colour'),
        idx = 0;
    for (idx; idx < inputs.length; idx += 1) {
        inputs[idx].style.backgroundColor = '';
    }
}
