clear;
path='D:\3_我的代码仓库\2_OnlineTS论文实验\data\AbileneNew.mat';
load(path);
DataName=AbileneDataNorm2;
[allDataI1,allDataI2,allDataI3]=size(DataName);%全部数据的维度
allDataI3=10000;
perAno=0.1;
trainingSliceNum=500;
numSliceForSketchStorageArr=[20];%20
[~,numSliceForSketchStorageArrLength]=size(numSliceForSketchStorageArr);

%[1,0.995,0.99,0.985,0.98,0.975,0.97,0.965,0.96,0.955,0.95,0.945,0.94,0.935,0.93,0.925,0.92,0.91,0.9,0.89,0.88,0.87,0.86,0.85,0.84,0.83,0.82,0.81,0.80,0.79,0.77,0.76,0.75,0.74,0.73,0.72,0.71,0.7,0.65,0.6,0.55,0.5,0.45,0.4];
%0.97
percentageCDFparaArr=[0.9648];%0.9648
[~,percentageCDFparaArrLength]=size(percentageCDFparaArr);
topKArr=[10];%10
[~,topKArrLength]=size(topKArr);
shrinkLevelArr=[5];%5
[~,shrinkLevelArrLength]=size(shrinkLevelArr);
numEx=1;%执行次数
%[0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09,0.1]
muArr=[0.1];
[~,muArrLength]=size(muArr);
sigmaArr=[0.005];
[~,sigmaArrLength]=size(sigmaArr);

disp("当前时间："+datestr(now)+",数据集："+path);
summaryStrTxt='D:\博士学习\（1）论文\tensor-SVD\data\summary.txt';
for f=1:numSliceForSketchStorageArrLength
    numSliceForSketchStorage=numSliceForSketchStorageArr(1,f);
    for i=1:shrinkLevelArrLength
        shrinkLevel=shrinkLevelArr(1,i);
        for j=1:percentageCDFparaArrLength
            percentageCDFpara=percentageCDFparaArr(1,j);
            for l=1:topKArrLength
                topK=topKArr(1,l);
                ID=randperm(10000000,1);%实验ID，为了方便查找原始数据文件
                for o=1:sigmaArrLength
                    sigma=sigmaArr(1,o);
                    for u=1:muArrLength
                        mu=muArr(1,u);
                        TPRArr=zeros(1,numEx);
                        FPRArr=zeros(1,numEx);
                        RecallArr=zeros(1,numEx);
                        PrecisionArr=zeros(1,numEx);
                        f1ScoreArr=zeros(1,numEx);
                        accuracyArr=zeros(1,numEx);
                        detTimeArr=zeros(1,numEx);
                        insertTimeArr=zeros(1,numEx);
                        for k=1:numEx
                            disp("topK="+topK);
                            [rateArr,trainingScore,norScoreArr,abnorScoreArr,TPR,FPR,Recall,Precision,f1Score,accuracy,detTime,insertTime,flagScore,trafficMatrixArr]=auto(DataName,ID,topK,shrinkLevel,allDataI3,trainingSliceNum,numSliceForSketchStorage,perAno,mu,sigma,percentageCDFpara,k,path);
                            TPRArr(1,k)=TPR;
                            FPRArr(1,k)=FPR;
                            RecallArr(1,k)=Recall;
                            PrecisionArr(1,k)=Precision;
                            f1ScoreArr(1,k)=f1Score;
                            accuracyArr(1,k)=accuracy;
                            detTimeArr(1,k)=detTime;
                            insertTimeArr(1,k)=insertTime;
                            rateArr=rateArr(rateArr>0);%topK占比
                            %disp("topK="+topK+",rateAver="+(sum(rateArr(1,1:10))/10));
                        end
                        averTPR=(sum(TPRArr)/numEx);
                        averFPR=(sum(FPRArr)/numEx);
                        averRecall=(sum(RecallArr)/numEx);
                        averPrecision=(sum(PrecisionArr)/numEx);
                        averF1Score=(sum(f1ScoreArr)/numEx);
                        averAccuracy=(sum(accuracyArr)/numEx);
                        averDetTime=(sum(detTimeArr)/numEx);
                        averInsertTime=(sum(insertTimeArr)/numEx);
                        disp("sigma="+sigma+",mu="+mu+",F1Score="+averF1Score+",allDataI3="+allDataI3+",trainingSliceNum="+trainingSliceNum+",numSliceForSketchStorage="+numSliceForSketchStorage+",topK="+topK+",shrinkLevel="+shrinkLevel+",percentageCDFpara="+percentageCDFpara+",TPR="+averTPR+",FPR="+averFPR+",Recall="+averRecall+",Precision="+averPrecision+",Accuracy="+averAccuracy+",averDetTime="+averDetTime+",averInsertTime="+averInsertTime+",flagScore="+flagScore+",ID="+ID);
                        %print(summaryStrTxt,ID,path,topK,shrinkLevel,allDataI3,trainingSliceNum,numSliceForSketchStorage,mu,sigma,percentageCDFpara,1,averTPR,averFPR,averRecall,averPrecision,averF1Score,averAccuracy,flagScore);
                    end
                    disp(" ");
                end
            end
        end
    end
end
[~,trafficMatrixArrLength]=size(trafficMatrixArr);
x=zeros(1,trafficMatrixArrLength);
for i=1:trafficMatrixArrLength
   x(1,i)=i; 
end
plot(x,trafficMatrixArr,'--x','color',[0.3 0.8 0.9],'lineWidth',1,'markersize',4);
grid on;
set(gca,'FontSize',30);




%%执行 
% TPRArr=zeros(numSliceForSketchStorageArrLength,percentageCDFparaArrLength);
% FPRArr=zeros(numSliceForSketchStorageArrLength,percentageCDFparaArrLength);
% RecallArr=zeros(numSliceForSketchStorageArrLength,percentageCDFparaArrLength);
% PrecisionArr=zeros(numSliceForSketchStorageArrLength,percentageCDFparaArrLength);
% f1ScoreArr=zeros(numSliceForSketchStorageArrLength,percentageCDFparaArrLength);
% accuracyArr=zeros(numSliceForSketchStorageArrLength,percentageCDFparaArrLength);
% flagScoreArr=zeros(numSliceForSketchStorageArrLength,percentageCDFparaArrLength);
% shrinkLevel=shrinkLevelArr(1,1);
% if (shrinkLevelArrLength~=1)
%     errID = 'myComponent:inputError';
%     msgtext = 'shrinkLevelArrLength~=1, Input does not have the expected format, please check the parameter above.';
%     ME = MException(errID,msgtext);%直接生成一个
%     throw(ME);
% end
% for y=1:numSliceForSketchStorageArrLength
%     numSliceForSketchStorage=numSliceForSketchStorageArr(1,y);
%     for i=1:percentageCDFparaArrLength
%         percentageCDFpara=percentageCDFparaArr(1,i);
%         for j=1:topKArrLength
%             topK=topKArr(1,j);
%             ID=randperm(10000000,1);%实验ID，为了方便查找原始数据文件
%             for o=1:sigmaArrLength
%                 sigma=sigmaArr(1,o);
%                 for u=1:muArrLength
%                     mu=muArr(1,u);
%                     [rateArr,trainingScore,norScoreArr,abnorScoreArr,TPR,FPR,Recall,Precision,f1Score,accuracy,detTime,flagScore]=auto(DataName,ID,topK,shrinkLevel,allDataI3,trainingSliceNum,numSliceForSketchStorage,perAno,mu,sigma,percentageCDFpara,0,path);
%                     TPRArr(y,i)=TPR;
%                     FPRArr(y,i)=FPR;
%                     RecallArr(y,i)=Recall;
%                     PrecisionArr(y,i)=Precision;
%                     f1ScoreArr(y,i)=f1Score;
%                     accuracyArr(y,i)=accuracy;
%                     flagScoreArr(y,i)=xiaoShuDian(flagScore,5);%
%                     disp("sigma="+sigma+",mu="+mu+",allDataI3="+allDataI3+",trainingSliceNum="+trainingSliceNum+",numSliceForSketchStorage="+numSliceForSketchStorage+",topK="+topK+",shrinkLevel="+shrinkLevel+",percentageCDFpara="+percentageCDFpara+",TPR="+TPR+",FPR="+FPR+",Recall="+Recall+",Precision="+Precision+",F1Score="+f1Score+",Accuracy="+accuracy+",flagScore="+flagScore+",ID="+ID);
%                     print(summaryStrTxt,ID,path,topK,shrinkLevel,allDataI3,trainingSliceNum,numSliceForSketchStorage,mu,sigma,percentageCDFpara,1,TPR,FPR,Recall,Precision,f1Score,accuracy,flagScore);
%                 end
%             end
%         end
%     end
%     TPRArr(y,:)=sort(TPRArr(y,:));
%     FPRArr(y,:)=sort(FPRArr(y,:));
%     disp("**********************************************************************");
% end
% 
% 
% 


