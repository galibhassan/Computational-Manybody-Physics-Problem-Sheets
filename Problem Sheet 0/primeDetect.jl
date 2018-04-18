# --- Primality tests ---
# --- API ---

##
#   isPrime()
#   input: int p
#   output: bool. according to p's primality
##
function isPrime(p)
    if (p<=0 || typeof(p) == Float16 || typeof(p) == Float32 || typeof(p) == Float64 )
        return false;
    elseif (p == 1 || p==2)
        return true;
    else
        for i=2:p
            if (p%i==0)
                return false;
            else
                if i>p/2
                    return true;
                end
            end
        end
    end
end


##
#   hasPrimeAhead(x, k)
#   input: int x, k
#   output: bool. Checks if x+k is prime or not.
##
function hasPrimeAhead(x, k)
    if isPrime(x+k)==true
        return true;
    else 
        return false;
    end    
end


##
#   hasPrimeBehind(x, k)
#   input: int x, k
#   output: bool. Checks if x-k is prime or not.
##
function hasPrimeBehind(x, k)
    if isPrime(x-k)==true
        return true;
    else 
        return false;
    end    
end

##
#   noOfPrimesUpTo(max, k, show)
#   input: int max, int k, string show
#   output: returns the number of prime-pairs up to max with k intervals. 
#           i.e. if n and n+k both prime, then counts one. 
#           Optional: if show = "show", then prints all those prime-pairs.            
##
function noOfPrimesUpTo(max, k, show)
    primePairCount = 0;
    for i = 1:max
        if(isPrime(i) && hasPrimeAhead(i,k)==true)
            primePairCount += 1;
            if (show == "show")
                print("$i-$(i+k), ");
            end
        end
    end
    return primePairCount;
end

# Problem specific logic ---

#=
k = 10;
max = 20000;
pairCount = noOfPrimesUpTo(max,k)
print("\nUp to $max, form n+$k \nno. of pairs: $pairCount \n");

=#