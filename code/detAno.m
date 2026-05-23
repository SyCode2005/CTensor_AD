

function [curScore]=detAno(testSlice,projectionTensor)
lateralSlice=tran(testSlice);
expression=(lateralSlice-tprod(projectionTensor,lateralSlice));
curScore=calTensorFrobenius(expression);%张量的F范数
end