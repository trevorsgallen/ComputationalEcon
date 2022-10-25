function y = examplefunction(x)
    global ysto xsto counter
    
    y = (x < 1).*1 + (x>=1).*3;
    
    if isempty(xsto) == 1
        xsto = x;
        ysto = y;
        counter = 1;
    else
        xsto(end+1)=x;
        ysto(end+1)=y;
        counter = counter+1;
    end
end