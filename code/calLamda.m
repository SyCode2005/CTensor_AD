function [rate]=calLamda(S,topK)
[I1,I2,~]=size(S);
minI=min(I1,I2);
hasSValue=0;
for i=1:topK
    hasSValue=hasSValue+S(i,i);
end
Svalue=0;
for i=1:minI
    Svalue=Svalue+S(i,i);
    if(S(i,i)<0)
        errID = 'myComponent:inputError';
        msgtext = 'S(i,i)有负数';
        ME = MException(errID,msgtext);%直接生成一个
        throw(ME);
    end
end
rate=hasSValue/Svalue;
end