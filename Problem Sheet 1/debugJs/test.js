
function isCommonIn(arr1, arr2) {
  for (i = 0; i < arr1.length; i++) {
    for (j = 0; j < arr2.length; j++) {
      if (arr1[i] == arr2[j]) {
        return true;
      }
    }
  }
  return false;
}

// var arr = [[5, 1], [6, 4], [7, 6], [5,2]];
var arr =  [[5, 1], [6, 4], [7, 6], [6, 4], [6, 4], [8, 6], [9, 8], [10,100], [30,20]];



function uniquizeArray(in_array) {
  var out_array = [];
  var matchFound;
  for (var i = 0; i < in_array.length; i++) {
    console.log(`${i}. `)
    matchFound = false;
    if (i === 0) {
      out_array.push(in_array[i]);
    }
    else {
      for (var k = 0; k < out_array.length; k++) {
        if (isCommonIn(in_array[i], out_array[k])) {
          
          for(var j=0; j<in_array[i].length; j++){
            out_array[k].push(in_array[i][j]);
          }
          console.log(`found match in_${i}, out_${k} `);
          console.log(`out_array : ${out_array.toString()}`);
          matchFound = true;
          break;
        }
      }
      if (matchFound === false) {
        console.log(`no match found. creating new node as out_${k + 1}`);
        out_array.push(in_array[i]);
        console.log(`out_array : ${out_array.toString()}`);
      }
    }
  }

  return out_array;
}



console.log(uniquizeArray(arr));
console.log("");