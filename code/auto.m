function [rateArr,trainingScore,norScoreArr,abnorScoreArr,TPR,FPR,Recall,Precision,f1Score,accuracy,detTime,insertTime,flagScore,trafficMatrixArr]=auto(DataName,ID,topK,shrinkLevel,allDataI3,trainingSliceNum,numSliceForSketchStorage,perAno,mu,sigma,percentageCDFpara,seq,path)

[allDataI1,allDataI2,~]=size(DataName);%全部数据的维度
trafficMatrixArr=zeros(1,allDataI3);
trafficMatrixArrCount=1;

deteionSliceNum=allDataI3-trainingSliceNum;
deteionSliceNum=4032*1;
%用于检测数据
%deteionSliceNum=4032*3;%Abilene数据
%deteionSliceNum=1344*6;%Geant数据
%disp("deteionSliceNum="+deteionSliceNum);
anomalySliceNum=round(deteionSliceNum*0.5);

tensorSketch=zeros(numSliceForSketchStorage,allDataI1,allDataI2);%新到来的矩阵是allDataI1×allDataI2
[tensorSketch_I1,tensorSketch_I2,tensorSketch_I3]=size(tensorSketch);
indexZero=1;
projectionTensor=zeros(tensorSketch_I2,tensorSketch_I2,tensorSketch_I3);%用张量V做异常检测

anomalySlicePos=randperm(deteionSliceNum,anomalySliceNum)+trainingSliceNum;%randperm(m,n)函数作用：从1-m中随机产生n个不重复的数
anomalySlicePos=sort(anomalySlicePos);%排序，使得随机选择的异常面序号从小到大排序
abnormalPointNum =round(allDataI1*allDataI2*perAno);%每个面注入异常的个数，百分比是perAno
rateArr=zeros(1,allDataI3);
rateArrCount=1;

%参数检测

if(topK>min(tensorSketch_I1,tensorSketch_I2) || shrinkLevel>min(tensorSketch_I1,tensorSketch_I2))
    errID = 'myComponent:inputError';
    msgtext = 'topK or shrinkLevel is  the expected format, please check the parameter above.';
    ME = MException(errID,msgtext);%直接生成一个
    throw(ME);
end



if(deteionSliceNum>(allDataI3-trainingSliceNum) ||   anomalySliceNum>deteionSliceNum )
    errID = 'myComponent:inputError';
    msgtext = 'topK is  the expected format, please check the parameter above.';
    ME = MException(errID,msgtext);%直接生成一个
    throw(ME);
end

trainingScore=zeros(1,trainingSliceNum-numSliceForSketchStorage);
abnorScoreArr=zeros(1,anomalySliceNum);
norScoreArr=zeros(1,deteionSliceNum-anomalySliceNum);
abnorScoreArrCount=1;
norScoreArrCount=1;

%%训练
for i=1:trainingSliceNum
    insertSlice=DataName(:,:,i);
    trafficMatrixArr(1,trafficMatrixArrCount)=insertSlice(1,1);
    trafficMatrixArrCount=trafficMatrixArrCount+1;
    HorizontalSilce=reshape(insertSlice,1,allDataI1,allDataI2);
    if(i>numSliceForSketchStorage)
       [curScore]=detAno(HorizontalSilce,projectionTensor); 
       trainingScore(1,i-numSliceForSketchStorage)=curScore;
    end
    [tensorSketch,indexZero,projectionTensor,rate]=insertByHorizontalSilce(tensorSketch,tensorSketch_I1,insertSlice,shrinkLevel,indexZero,topK,projectionTensor);   
    rateArr(1,rateArrCount)=rate;
    rateArrCount=rateArrCount+1;
end
trainingScore=sort(trainingScore);
flagScore=trainingScore(1,round((trainingSliceNum-numSliceForSketchStorage)*percentageCDFpara));
%disp("flagScore="+flagScore);
%flagScore=2.412906906892365e-04;
%%

%%异常检测部分
TP=0;%异常判断为异常
FP=0;%正常判断为异常

FN=0;%异常判断为正常
TN=0;%正常判断为正常

timeArr1=zeros(1,deteionSliceNum);
timeArr1Count=1;
timeArr2=zeros(1,deteionSliceNum);
timeArr2Count=1;

for i=1:deteionSliceNum
    testSlice=DataName(:,:,i+trainingSliceNum);%某一面的矩阵
    if(ismember(trainingSliceNum+i,anomalySlicePos)==1)%如果这个面是异常面
        %生成异常值
        outliers=normrnd(mu,sigma,[1,abnormalPointNum]);%从均值参数为 mu 和标准差参数为 sigma 的正态分布中生成 1×outliersNum的异常值
        pos=randperm(allDataI1*allDataI2, abnormalPointNum);%randperm(m,n)函数作用：从1-m中随机产生n个不重复的数
        pos=sort(pos);%排序，使得随机选择的异常面序号从小到大排序
        for j=1:abnormalPointNum
            posX1=floor(pos(1,j)./allDataI1)+1;
            posX2=mod(pos(1,j),allDataI2);
            if(posX2==0)
                posX1=posX1-1;
                posX2=allDataI2;
            end
            if(posX1<1 || posX1>23 ||  posX2<1 || posX2>23)
                errID = 'myComponent:inputError';
                msgtext = 'Input does not have the expected format, please check the parameter above.';
                ME = MException(errID,msgtext);%直接生成一个
               throw(ME);
            end
            testSlice(posX1,posX2)=testSlice(posX1,posX2)+outliers(1,j);
            if(posX1==1 && posX2==1)
                %disp("trafficMatrixArrCount="+trafficMatrixArrCount);
            end
        end
        trafficMatrixArr(1,trafficMatrixArrCount)=testSlice(1,1);
        trafficMatrixArrCount=trafficMatrixArrCount+1;
         %开始异常检测
        HorizontalSilce=reshape(testSlice,1,allDataI1,allDataI2);
        time1=cputime;
        [curScore]=detAno(HorizontalSilce,projectionTensor); 
        time2=cputime; 
        timeArr1(1,timeArr1Count)=time2-time1;
        timeArr1Count=timeArr1Count+1;
        
        abnorScoreArr(1,abnorScoreArrCount)=curScore;
        abnorScoreArrCount=abnorScoreArrCount+1;
        if(curScore>flagScore)
            TP=TP+1;
        else%异常，但是判断成正常
            FN=FN+1;
            time1=cputime;
            [tensorSketch,indexZero,projectionTensor,rate]=insertByHorizontalSilce(tensorSketch,tensorSketch_I1,testSlice,shrinkLevel,indexZero,topK,projectionTensor);   
            time2=cputime; 
            timeArr2(1,timeArr2Count)=time2-time1;
            timeArr2Count=timeArr2Count+1;
            rateArr(1,rateArrCount)=rate;
            rateArrCount=rateArrCount+1;
        end       
    else
        trafficMatrixArr(1,trafficMatrixArrCount)=testSlice(1,1);
        trafficMatrixArrCount=trafficMatrixArrCount+1;
        HorizontalSilce=reshape(testSlice,1,allDataI1,allDataI2);
        
        time1=cputime;
        [curScore]=detAno(HorizontalSilce,projectionTensor); 
        time2=cputime; 
        timeArr1(1,timeArr1Count)=time2-time1;
        timeArr1Count=timeArr1Count+1;
        
        norScoreArr(1,norScoreArrCount)=curScore;
        norScoreArrCount=norScoreArrCount+1;
        if(curScore>flagScore)
            FP=FP+1; 
        else
            TN=TN+1;
            time1=cputime;
            [tensorSketch,indexZero,projectionTensor,rate]=insertByHorizontalSilce(tensorSketch,tensorSketch_I1,testSlice,shrinkLevel,indexZero,topK,projectionTensor);
            time2=cputime;
            timeArr2(1,timeArr2Count)=time2-time1;
            timeArr2Count=timeArr2Count+1;
            
            rateArr(1,rateArrCount)=rate;
            rateArrCount=rateArrCount+1;
        end  
    end
end

detTime=sum(timeArr1);
insertTime=sum(timeArr2);
norScoreArr=sort(norScoreArr);
abnorScoreArr=sort(abnorScoreArr);
TPR=(TP/anomalySliceNum);
FPR=(FP/(deteionSliceNum-anomalySliceNum));

%TPR=TP/(TP+FN);
%FPR=FP/(FP+TN);
Recall=TP/(TP+FN);
Precision=TP/(TP+FP);
f1Score=2*(Precision*Recall)/(Precision+Recall);
accuracy=(TP+TN)/(TP+FP+FN+TN);
%disp("TPR="+TPR+",FPR="+FPR);
strTxt='D:\博士学习\（1）论文\tensor-SVD\data\eachResult.txt';
%print(strTxt,ID,path,topK,shrinkLevel,allDataI3,trainingSliceNum,numSliceForSketchStorage,mu,sigma,percentageCDFpara,seq,TPR,FPR,Recall,Precision,f1Score,accuracy,flagScore);
end


