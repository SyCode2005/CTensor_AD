clc;
clear;
n=10;
I1=n;
I2=5;
I3=5;
L=4;
% A=zeros(n,I2,I3);
% A(:,:,1)=[0.559370572403004,0.848709226458282,0.505133101798823;0.004579623947323,0.916821270253738,0.271421624417515;0.766681998621487,0.986968274783658,0.100750511921236];
% A(:,:,2)=[0.507848830829537, 0.082962649110544, 0.171048017525447;0.585609125701878,0.661596193082714,0.938557864331842;0.762887095910741,0.516979014706213,0.590483177142572];
% A(:,:,3)=[0.440634680760840,0.451945709260386,0.553887065791275;0.941918930311283,0.839697420719669,0.680065530083361;0.655913820257141,0.532623502474346,0.367189905317367];
A=rand(n,I2,I3);
B=zeros(L,I2,I3);
shrinkLevel=min(L,I2);
indexZore=1;
for i=1:n
    B(indexZore,:,:)=A(i,:,:);
    indexZore=indexZore+1;
    if(indexZore>L)
        [~,S,V]=tensorSvd(B);
        [newS,shrinkVal]=shrinkOperationRow(S,shrinkLevel);
        B=tprod(newS,tran(V));
        indexZore=shrinkLevel;
    end
end
expression1=tprod(tran(A),A)-tprod(tran(B),B);
disp("expression1="+calTensorFrobenius(expression1));
%张量HOOI分解
T=tucker_als(tensor(A),[I1-2,I2-2,I3-2]);
expression2=tprod(tran(A),A)-tprod(tran(double(T)),double(T));

disp("expression2="+calTensorFrobenius(expression2)+",calTensorFrobenius(T-A)="+calTensorFrobenius(double(T)-double(A)));
%
% A=zeros(2,2,2);
% A(:,:,1)=[11,12;13,14];
% A(:,:,2)=[21,22;23,24];
% disp(tprod(tran(A),A));

function [newS,shrinkVal]=shrinkOperationRow(S,shrinkLevel)
[I1,I2,I3]=size(S);
S_FFT=fft(S,[],3);%求S在快速傅里叶变换下张量S_FFT
S_FFT_square=zeros(I1,I2,I3);
%S_FFT_bdiag=bdiag(S_FFT);
%S_FFT_bdiag_square=S_FFT_bdiag'*S_FFT_bdiag;
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



%已经变成函数脚本
% function [val]=calTensorNorm2(A)
% expression=bdiag(fft(A,[],3));
% val=norm(expression,2);
% end


function [matrix]=transTensor(beforeTensor)
[I1,I2,I3]=size(beforeTensor);
afterTensor=zeros(I3,I2,I1);
for i=1:I1
    tube=beforeTensor(i,:,:);
    afterTensor(:,:,i)=transTube(tube);
end
matrix=zeros(I3*I1,I2);
beginFlag=1;
endFlag=I3;
for i=1:I1
    matrix(beginFlag:endFlag,:)=afterTensor(:,:,i);
    beginFlag=beginFlag+I3;
    endFlag=endFlag+I3;
end
end



function [slice]=transTube(tube)
[~,I2,I3]=size(tube);
slice=zeros(I2,I3);
for i=1:I3
    slice(i,:)=tube(1,:,i);
end
end




function [value]=calC(C,x)
[I1,I2,I3]=size(C);
value=0;
for i=1:I2
    slice=C(:,i,:);
    newSlice=zeros(I1,I3);
    for j=1:I1
        for k=1:I3
           newSlice(j,k)=slice(j,1,k);
        end        
    end
    value=value+norm(newSlice*x,2)^2;
end
end


function [U,S,V]=tensorSvd(B)
B=fft(B,[],3);
[I1,I2,I3]=size(B);
U=zeros(I1,I1,I3);
S=zeros(I1,I2,I3);
V=zeros(I2,I2,I3);
for i=1:I3
   [U(:,:,i),S(:,:,i),V(:,:,i)]=svd(B(:,:,i));
end
U=ifft(U,[],3);
S=ifft(S,[],3);
V=ifft(V,[],3);
end













