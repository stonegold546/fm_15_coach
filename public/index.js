/*jslint browser:true */
/*jslint forin:true */

var inputs = document.getElementsByClassName('data');

function clearFunction() {
    "use strict";
    var idx = 0;
    for (idx; idx < inputs.length; idx += 1) {
        inputs[idx].value = '1';
    }
}

function copyFunction(val) {
    "use strict";
    var new_val = JSON.parse(JSON.stringify(val)),
        idx = 0;
    for (idx; idx < inputs.length; idx += 1) {
        inputs[idx].value = new_val[inputs[idx].name];
    }
}

var idx,
    input;

for (idx = 0; idx < inputs.length; idx += 1) {
    input = inputs[idx];
    input.addEventListener('input', function () {
        "use strict";
        var ind = 0,
            myResult = new XMLHttpRequest(),
            url = '/?api=y'.concat(
                '&attacking=',
                inputs[0].value,
                '&defending=',
                inputs[1].value,
                '&fitness=',
                inputs[2].value,
                '&goalkeepers=',
                inputs[3].value,
                '&mental=',
                inputs[4].value,
                '&tactical=',
                inputs[5].value,
                '&technical=',
                inputs[6].value,
                '&determination=',
                inputs[7].value,
                '&discipline=',
                inputs[8].value,
                '&motivating=',
                inputs[9].value
            );
        for (ind; ind < inputs.length; ind += 1) {
            if (parseInt((inputs[ind].value), 10) < 1) {
                inputs[ind].value = '1';
            } else if (inputs[ind].value.length > 2) {
                inputs[ind].value = inputs[ind].value.substring(0, 2);
            } else if (parseInt((inputs[ind].value), 10) > 20) {
                inputs[ind].value = '20';
            }
        }
        myResult.open('GET', url, true);
        myResult.send();
        myResult.onreadystatechange = function () {
            var stars = document.getElementsByClassName('star'),
                data = JSON.parse(myResult.responseText),
                inner_idx = 0,
                i;
            for (i in data) {
                stars[inner_idx].innerHTML = data[i];
                inner_idx += 1;
            }
        };
    });
}
