%%% RTdistribution.m
% to inspect the RT distribution with eyes
% coded by Jane
% last edit: 20180822 Wed

%% =======================================================================
% %                 DATA INSPECTION : RT distribution
% ========================================================================
numBin = 12;    %binning for RT distribution
whatSD = 2.5;   %specify SD range
for iFig = 1:2
    figure;
    for iSub = 1:length(Custom.subNames)
        Data(iSub).stat.RT1(1) = mean(Data(iSub).RT1);  %mean
        Data(iSub).stat.RT1(2) = std(Data(iSub).RT1);   %std
        %Data(iSub).stat.RT1(3) = isoutlier(Data(iSub).RT1,'mean'); %3std
        %MATLAB2018
        Data(iSub).stat.RT2(1) = mean(Data(iSub).RT2);  %mean
        Data(iSub).stat.RT2(2) = std(Data(iSub).RT2);   %std
        %Data(iSub).stat.RT2(3) = isoutlier(Data(iSub).RT2,'mean'); %3std
        %MATLAB 2018
        % shortcut
        RT1mean=Data(iSub).stat.RT1(1);
        RT2mean=Data(iSub).stat.RT2(1);
        RT1std=whatSD*Data(iSub).stat.RT1(2);
        RT2std=whatSD*Data(iSub).stat.RT2(2);
        
        switch iFig
            case 1
                %RT1
                subplot(5,5,iSub);
                histogram(Data(iSub).RT1,numBin);
                hold on;
                line([RT1mean RT1mean],ylim,'Color','b');
                line([0 0],ylim,'Color','black');
                line([4 4],ylim,'Color','black');
                line(RT1mean-RT1std*[1 1],ylim,'Color','r');
                line(RT1mean+RT1std*[1 1],ylim,'Color','r');
                title(strcat('RT1 distribution ',Custom.subNames{iSub}));                
                axis([-2 5 0 250]);
                xlabel('RT1');
                ylabel('Frequency');
            case 2
                %RT2
                subplot(5,5,iSub);
                histogram(Data(iSub).RT2,numBin);
                hold on;
                line([RT2mean RT2mean],ylim,'Color','b');
                line([0 0],ylim,'Color','black');
                line([4 4],ylim,'Color','black');
                line(RT2mean-RT2std*[1 1],ylim,'Color','r');
                line(RT2mean+RT2std*[1 1],ylim,'Color','r');
                title(strcat('RT2 distribution ',Custom.subNames{iSub}))
                axis([-2 5 0 250]);
                xlabel('RT2');
                ylabel('Frequency');
        end
        % inlier =1 , outlier = 0
        Data(iSub).InOut{1}= [(Data(iSub).RT1>(RT1mean-RT1std))&(Data(iSub).RT1<(RT1mean+RT1std))];
        Data(iSub).InOut{2}= [(Data(iSub).RT2>RT2mean-RT2std)&(Data(iSub).RT2<RT2mean+RT2std)];
        % count how many outliers are there
        Data(iSub).howManyOut(1) = length(Data(iSub).RT1)-nnz(Data(iSub).InOut{1});
        Data(iSub).howManyOut(2) = length(Data(iSub).RT2)-nnz(Data(iSub).InOut{2});
        
        % filter only those outlier and incorrect = 1
        Data(iSub).OutIncorrect{1}= [(Data(iSub).InOut{1}==0)&(Data(iSub).Acc==0)];
        Data(iSub).OutIncorrect{2}= [(Data(iSub).InOut{2}==0)&(Data(iSub).Acc==0)];
        % count how many outlier & incorrect are there
        Data(iSub).howManyIncorrectOut(1) = nnz(Data(iSub).OutIncorrect{1});
        Data(iSub).howManyIncorrectOut(2) = nnz(Data(iSub).OutIncorrect{2});
        % count how many outlier & correct are there
        Data(iSub).howManyCorrectOut(1) = Data(iSub).howManyOut(1)-nnz(Data(iSub).OutIncorrect{1});
        Data(iSub).howManyCorrectOut(2) = Data(iSub).howManyOut(2)-nnz(Data(iSub).OutIncorrect{2});
    end % ... subject loop
end %... fig
