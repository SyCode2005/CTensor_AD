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
fprintf(fid,' flagScore= %.12f ',flagScore);
fprintf(fid,' percentageCDFpara=%d\n',percentageCDFpara);
fprintf(fid,'mu = %f ',mu);
fprintf(fid,', sigma = %f\n',sigma);
fprintf(fid,'TPR= %.8f ',TPR);
fprintf(fid,', FPR= %.8f ',FPR);
fprintf(fid,', Recall= %.8f ',Recall);
fprintf(fid,', Precision= %.8f ',Precision);
fprintf(fid,', f1Score= %.8f ',f1Score);
fprintf(fid,', accuracy= %.8f ',accuracy);
fprintf(fid,'\n');
fprintf(fid,'\n');
fclose(fid);
end