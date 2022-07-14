function [output1,otherstuff] = SampleFunction(x,y,z)
    output1 = x+y;
    otherstuff.output2 = x-y;
    otherstuff.output3 = (x+y) == (x-y);
        z = 1;

    otherstuff.output4 = z;
end