%%% RTdistribution.m
% to inspect the RT distribution with eyes
% coded by Jane
% last edit: 20180801 Wed

%% =======================================================================
% %                 DATA INSPECTION : RT distribution
% ========================================================================
numBin = 10;
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
        RT1mean=Data(iSub).stat.RT1(1);
        RT2mean=Data(iSub).stat.RT2(1);
        RT1std25=2.5*Data(iSub).stat.RT1(2);
        RT2std25=2.5*Data(iSub).stat.RT2(2);
        
        switch iFig
            case 1
                %RT1
                subplot(5,5,iSub);
                histogram(Data(iSub).RT1,numBin);
                hold on;
                line([RT1mean RT1mean],ylim,'Color','b');
                line([0 0],ylim,'Color','black');
                line([4 4],ylim,'Color','black');
                line([RT1mean-RT1std25 RT1mean-RT1std25],ylim,'Color','r');
                line([RT1mean+RT1std25 RT1mean+RT1std25],ylim,'Color','r');
                title(sprintf('RT1 distribution Subj%d',iSub));
            case 2
                %RT2
                subplot(5,5,iSub);
                histogram(Data(iSub).RT2,numBin);
                hold on;
                line([RT2mean RT2mean],ylim,'Color','b');
                line([0 0],ylim,'Color','black');
                line([4 4],ylim,'Color','black');
                line([RT2mean-RT2std25 RT2mean-RT2std25],ylim,'Color','r');
                line([RT2mean+RT2std25 RT2mean+RT2std25],ylim,'Color','r');
                title(sprintf('RT2 distribution Subj%d',iSub));
        end
    end
end
