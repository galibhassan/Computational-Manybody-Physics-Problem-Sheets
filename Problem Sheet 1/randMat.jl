using PyPlot;

function RandMatZeroOneWithDimAndProb(L, p)
  tempRandMat = reshape(1:L*L, L, L)*0;
  noOfRows = size(tempRandMat)[1];
  noOfCols = size(tempRandMat)[2];
  for i=1:noOfRows
    for j=1:noOfCols ; 
      tempRandMat[i,j] = rand(0:1);
    end    
  end
  for k = 1:L*L*3 -1:L*L*3 
    tempRandMat[rand(1:L),rand(1:L) ] = 0;
  end
  return tempRandMat;
end

function matrixPlot(in_mat)
  matshow(in_mat);  
end


print("Info: randMat.jl is called. ");


