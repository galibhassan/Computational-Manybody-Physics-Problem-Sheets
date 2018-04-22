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

# 
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
            eqUpCell = labelMat[i-1, j];
            eqLeftCell = labelMat[i, j - 1];
        end
    end
    return (currentLabel, [eqLeftCell, eqUpCell]);
end


function getLabelMat(targetMat)
    labelMat = targetMat*0;
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
    eqLabelsMerged = getEquivalentClasses(eqLabels);
    println(eqLabelsMerged);
    return [labelMat, eqLabelsMerged];
end

function mergeEqualLabels(mergerArr, labelMat)
    tempLm =  labelMat;
    for k = 1:length(mergerArr)
        for i=1:size(tempLm)[1]
            for j=1:size(tempLm)[2]
                if(tempLm[i,j] == mergerArr[k][1] || tempLm[i,j] == mergerArr[k][2] )
                   tempLm[i,j] =  smallerOf( mergerArr[k][1], mergerArr[k][2]  );
                end
            end
        end
    end
    return tempLm;
end



