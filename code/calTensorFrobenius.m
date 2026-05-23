%计算张量的F范数
function [value2]=calTensorFrobenius(X)
[~,~,I3]=size(X);
% %计算方法一：各个元素的平方和再开方
% value1=0;
% for i=1:I1
%     for j=1:I2
%         for k=1:I3
%             value1=value1+X(i,j,k)^2;
%         end
%     end
% end
% value1=sqrt(value1);
%计算方法二：对张量X求FFT下的块对角矩阵，求F范数，再乘上1/根号(n3)
X_FFT=bdiag(fft(X,[],3));
value2=norm(X_FFT,'f');
value2=value2*1/((I3)^0.5);
% %计算方法三：对张量X求FFT下的块对角矩阵，求协方差矩阵的迹，再除以(n3)
% X_FFT_cov= X_FFT'* X_FFT;
% value3=sqrt(trace(X_FFT_cov)/I3);
end