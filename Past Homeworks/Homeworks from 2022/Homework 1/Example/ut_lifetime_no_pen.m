function out = ut_lifetime_no_pen(c,l,beta,per,U_cl,A,b,pen)

    out=sum((beta.^per).*U_cl(c,l));
    if pen == 1 & (min(c)<0 | min(l)<0)
        out = -1000;
    end
end
