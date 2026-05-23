% clc;
% clear;
% n=10;
% I1=n;
% I2=5;
% I3=4;
% L=4;
% A=zeros(n,I2,I3);
% B=zeros(L,I2,I3);
% shrinkLevel=round(min(L,I2));
% indexZore=1;
% shrinkVal=zeros(1,I3);
% A=rand(n,I2,I3);
% traceSnewS=0;
% for i=1:n
%     B(indexZore,:,:)=A(i,:,:);
%     indexZore=indexZore+1;
%     if(indexZore>L)
%          [U,S,V]=tensorSvd(B);
%           [newS,shrinkVal]=shrinkOperationRow(S,shrinkLevel);
%           %disp("选取的shrinkVal的值分别是：");
%           %disp(shrinkVal); 
%           B=tprod(newS,tran(V));       
%           indexZore=shrinkLevel;         
%     end
%     lastB=B;
% end

%检查一下这个函数有没有问题 


function [tensorSketch,indexZero,projectionTensor,rate]=insertByHorizontalSilce(tensorSketch,tensorSketch_I1,insertSlice,shrinkLevel,indexZero,topK,projectionTensor)
tensorSketch(indexZero,:,:)=insertSlice;
indexZero=indexZero+1;
rate=0;
if(indexZero>tensorSketch_I1)
    [~,S,V]=tensorSvd(tensorSketch);
    [newS,~]=shrinkOperationRow(S,shrinkLevel);
    %%计算topK的贡献率
    [rate]=calLamda(S,topK);
    %disp("topK="+topK+",rate="+rate);
    %disp("选取的shrinkVal的值分别是：");
    %disp(shrinkVal);
    tensorSketch=tprod(newS,tran(V)); 
    projectionTensor=tprod(V(:,1:topK,:),tran(V(:,1:topK,:)));
    %projectionTensor=tprod(V(:,topK,:),tran(V(:,topK,:)));
    indexZero=shrinkLevel;    
end
end



function [newS,shrinkVal]=shrinkOperationRow(S,shrinkLevel)
[I1,I2,I3]=size(S);
S_FFT=fft(S,[],3);%求S在快速傅里叶变换下张量S_FFT
S_FFT_square=zeros(I1,I2,I3);
%S_FFT_bdiag=bdiag(S_FFT);
% S_FFT_bdiag_square=S_FFT_bdiag'*S_FFT_bdiag;
% for i=1:I3
%     disp("i="+S_FFT_bdiag_square(shrinkLevel+(I2*(i-1)),shrinkLevel+(I2*(i-1))));
% end
cut=zeros(I1,I2,I3);
newS=zeros(I1,I2,I3);
minI=min(I1,I2);
shrinkVal=zeros(1,1,I3);
for i=1:I3
    for j=1:minI
        S_FFT_square(j,j,i)=S_FFT(j,j,i)^2;%对张量S_FFT的每一面的斜对角元素求平方
    end
    shrinkVal(1,1,i)=S_FFT_square(shrinkLevel,shrinkLevel,i);
    %disp("shrinkVal(1,1,i)  i="+i+","+shrinkVal(1,1,i));
    for j=1:minI
        cut(j,j,i)=shrinkVal(1,1,i);
    end
end
for i=1:I3
    temp=max(S_FFT_square(:,:,i)-cut(:,:,i),0);
    newS(:,:,i)=sqrt(temp);
end
newS=ifft(newS,[],3);%对缩减后的张量newS进行逆傅里叶变换
end












