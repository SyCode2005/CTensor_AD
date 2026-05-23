%DataName,topK,shrinkLevel,allDataI3,trainingSliceNum,numSliceForSketchStorage,mu,sigma,percentageCDFpara,seq

function []=print(strTxt,ID,path,topK,shrinkLevel,allDataI3,trainingSliceNum,numSliceForSketchStorage,mu,sigma,percentageCDFpara,seq,TPR,FPR,Recall,Precision,f1Score,accuracy,flagScore)
fid = fopen(strTxt,'a');
str1=datestr(now);
fprintf(fid,'%s ',path); 
fprintf(fid,'%s\n',str1); 
fprintf(fid,'seq=%d, ',seq); 
fprintf(fid,' ID= %d ,\n',ID); 
fprintf(fid,'topK=%d, ',topK); 
fprintf(fid,' shrinkLevel=%d, ',shrinkLevel);
fprintf(fid,' allDataI3=%d, ',allDataI3);
fprintf(fid,' trainingSliceNum=%d, ',trainingSliceNum);
fprintf(fid,' numSliceForSketchStorage=%d, ',numSliceForSketchStorage);
fprintf(fid,' flagScore= %.12f ',flagScore); %数据类型为整数，中间以逗号分隔
fprintf(fid,' percentageCDFpara=%d\n',percentageCDFpara);

fprintf(fid,'mu = %f ',mu); 
fprintf(fid,', sigma = %f\n',sigma);
fprintf(fid,'TPR= %.8f ',TPR); %数据类型为整数，中间以逗号分隔
fprintf(fid,', FPR= %.8f ',FPR); %数据类型为整数，中间以逗号分隔
fprintf(fid,', Recall= %.8f ',Recall); %数据类型为整数，中间以逗号分隔
fprintf(fid,', Precision= %.8f ',Precision); %数据类型为整数，中间以逗号分隔
fprintf(fid,', f1Score= %.8f ',f1Score); %数据类型为整数，中间以逗号分隔
fprintf(fid,', accuracy= %.8f ',accuracy); %数据类型为整数，中间以逗号分隔
fprintf(fid,'\n');
fprintf(fid,'\n');
fclose(fid);
end