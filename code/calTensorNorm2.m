function [val]=calTensorNorm2(A)
%  expression=bdiag(fft(A,[],3))*bdiag(fft(B,[],3));
%  val=norm(expression,2);
expression=bdiag(fft(A,[],3));
val=norm(expression,2);
end


