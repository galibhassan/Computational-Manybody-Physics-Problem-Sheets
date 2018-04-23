print("Info: hoshenKopelman.jl is called. ");

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

# takes a parent array of several children arrays as input, checks if those children arrays have common elements among each other.
# if yes, then merge those children arrays into a single child array. 
# if no, then appends a new child array. 
# returns the parent array with equivalence classes
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



# checks if a cell is occupied
function isOccupied(mat, i, j)
    if(mat[i,j] == 1)
        return true;
    elseif (mat[i,j] == 0)
        return false;
    end
end

# checks if the left- or the up-cell is occupied 
function isClustered(mat, i, j)
    if(i == 1 && j == 1)
        return [false, "none"];
    elseif(i > 1 && j > 1)
        if(isOccupied(mat, i, j - 1) == true && isOccupied(mat, i - 1, j) == true)
            return [true, "both"];
        elseif(isOccupied(mat, i, j - 1) == true)
            return [true, "left"];
        elseif(isOccupied(mat, i - 1, j) == true)
            return [true, "up"];
        else
            return [false, "none"];
        end
    elseif(i == 1)
        if(isOccupied(mat, i, j - 1) == true)
            return [true, "left"];
        else
            return [false, "none"];
        end
    elseif(j == 1)
        if(isOccupied(mat, i - 1, j) == true)
            return [true, "up"];
        else
            return [false, "none"]
        end
    else 
        return [false, "none"];
    end
end

# returns the smaller number between a and b
function smallerOf(a, b)
    if(a < b)
        return a;
    elseif(a > b)
        return b;
    else
        return a;
    end
end


# create a new label (looks unnecessary, but helps to understand the flow)
function newLabel(highestLabel)
    return highestLabel + 1;     
end

# sets a label of a matrix-entry according to Hoshen-Kopelman algorithm
function setLabel(targetMat, labelMat, i, j, currentLabel)
    eqUpCell = 0;
    eqLeftCell = 0;

    if(isClustered(targetMat, i, j)[1] == false)
        highestLabel = maximum(labelMat);
        labelMat[i,j] = newLabel(highestLabel);
        currentLabel = labelMat[i,j];

    elseif( isClustered(targetMat, i, j)[1] == true )
        _clustWith = isClustered(targetMat, i, j)[2];

        if(_clustWith == "left")
            labelMat[i,j] = labelMat[i, j - 1];
            currentLabel = labelMat[i,j];
            highestLabel = maximum(labelMat);

        elseif(_clustWith == "up" )
            labelMat[i,j] = labelMat[i - 1, j];
            currentLabel = labelMat[i,j];  
            highestLabel = maximum(labelMat);  

        elseif(_clustWith == "both")
            labelMat[i,j] = smallerOf(labelMat[i, j - 1], labelMat[i - 1,j]);
            currentLabel = labelMat[i,j];
            highestLabel = maximum(labelMat);
            eqUpCell = labelMat[i - 1, j];
            eqLeftCell = labelMat[i, j - 1];
        end
    end
    return (currentLabel, [eqLeftCell, eqUpCell]);
end


#checks if an element exists in an array
function doesExistIn(arr, el)
    for i = 1:length(arr) 
        if(arr[i] == el)
            return true;
        end
    end    
    return false;
end

# merges equivalent clusters (in hoshen-kopelman, the ones resulting "both")
function mergeEquivalentClusters(labelMat, mergerArray)
    tempLabelMat = labelMat;
    for k = 1:length(mergerArray) 
        for i = 1:size(tempLabelMat)[1] 
            for j = 1:size(tempLabelMat)[2] 
                if( doesExistIn(mergerArray[k], tempLabelMat[i,j]) == true)
                    tempLabelMat[i,j] = mergerArray[k][1];
                end
            end    
        end      
    end  
    return tempLabelMat;
end



function getLabelMat(targetMat)
    labelMat = targetMat * 0;
    currentLabel = 0;
    eqLabels = [];
    highestLabel = maximum(labelMat);
    for i = 1:size(labelMat)[1]
        for j = 1:size(labelMat)[2]         
            if(targetMat[i,j] == 0)
                labelMat[i,j] = 0;
            else 
                setLabel_Output = setLabel(targetMat, labelMat, i, j, currentLabel);
                currentLabel = setLabel_Output[1];

                if(setLabel_Output[2][1] != setLabel_Output[2][2])
                    push!(eqLabels, setLabel_Output[2]);
                end
            end
        end
    end
    
    println(eqLabels);
    print("\n");
    # this is a hack. for some use cases i found some clusters not merged. so to make sure, running the merging process second time crears them. 
    # sorry for the unsmartness, but it works. 
    eqLabelsMerged = getEquivalentClasses(getEquivalentClasses(eqLabels));
    println(eqLabelsMerged);
    print("\n");
    finalLabelMat = mergeEquivalentClusters(labelMat, eqLabelsMerged);
    return finalLabelMat;
end

# counts the number of clusters from a labeled-matrix
function getNoOfClusters(labelMat)
    clustArray = union(labelMat);
    return length(clustArray)-1;
    # subtraction by 1 is because 0-label is also considered as a cluster
end
