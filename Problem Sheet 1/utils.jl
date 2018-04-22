# compares if there is something common between arr1 and arr2
function isCommonIn(arr1, arr2)
    for i = 1:length(arr1)
        for j = 1:length(arr2)
            if(arr1[i] == arr2[j])
                return true;
            end
        end
    end
    return false;
end

# takes two arrays, compare them, returns a structure with "uniqueness". 
function uniquizeArrays(arr1, arr2)
    arr1 = union(arr1);
    arr2 = union(arr2);
    uniqueArr = [];
    push!(uniqueArr, arr1);
    if(isCommonIn(arr1, arr2) == true)
        for i = 1:length(arr2)        
            push!(uniqueArr[1], arr2[i]);
        end
        uniqueArr = union(uniqueArr[1]);
    else
        push!(uniqueArr, arr2);
    end
      
    return uniqueArr;
end




function getEquivalentClasses(in_array)
    out_array = [];
    matchFound = false;

    for i = 1:length(in_array) 
        matchFound = false;
        if(i == 1)
            push!(out_array, in_array[i]);
        else
            for k = 1:length(out_array)
                if( isCommonIn(in_array[i], out_array[k]) )
                    for j = 1:length(in_array[i])
                        push!(out_array[k], in_array[i][j]);                        
                        #print("\n   out[$k] = $(out_array[k]),  \t\t\t in[$i][$j] = $(in_array[i][j]) ");
                    end
                    matchFound = true;
                    break;
          
                end
            end
            if(matchFound == false)
                push!(out_array, in_array[i]);
            end
        end
    end

    for i = 1:length(out_array)
        out_array[i] = union(out_array[i]); 
    end

    return out_array;
end

print("\nInfo: utils.jl is called.")












