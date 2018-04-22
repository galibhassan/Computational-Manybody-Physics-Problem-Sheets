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

