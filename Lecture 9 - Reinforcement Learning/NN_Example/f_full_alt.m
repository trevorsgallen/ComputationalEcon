function out = f_full_alt(theta,f_full)
    persistent counter error
    if exist('counter')==0 || isempty(counter)
        counter = 0;
    else
        counter = counter+1;
    end
    if exist('error')==0 || isempty(error)
        error = Inf;
    end
    
    out = f_full(theta);
    if sum(out.^2) < error./10
        error = sum(out.^2);
        plot(out)
        hold on
        drawnow
        error
    end
end