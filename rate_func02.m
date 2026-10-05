%Function that outputs the slope of rate_func01 at a given 
% X value and time t.
function dXdt = rate_func02(t,X)
    dXdt = [0,-1;1,0]*X;
end